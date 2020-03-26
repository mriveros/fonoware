class PacientesController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index
  

  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_paciente_id].present?

      cond << "pacientes.paciente_id = ?"
      args << params[:form_buscar_paciente_id]

    end

    if params[:form_buscar_paciente_documento].present?

      cond << "pacientes.ruc = ?"
      args << params[:form_buscar_paciente_documento]

    end

    if params[:form_buscar_paciente_nombre].present?

      cond << "pacientes.cliente_nombre ilike ?"
      args << "%#{params[:form_buscar_paciente_nombre]}%"

    end

    if params[:form_buscar_paciente_apellido].present?

      cond << "pacientes.cliente_apellido ilike ?"
      args << "%#{params[:form_buscar_paciente_apellido]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @pacientes =  VPaciente.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VPaciente.where(cond).count

    else

      @pacientes = VPaciente.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VPaciente.count

    end

    @total_registros = VPaciente.count

  	respond_to do |f|
	    
	   f.js
	    
	  end

  end

  def agregar

    @paciente = paciente.new

    respond_to do |f|
	    
	      f.js
	    
	  end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false

    unless params[:paciente][:paciente_documento].present?

      @valido = false
      @msg += " Debe Completar el campo Nombre. \n"

    end

    if @valido
      
      @paciente = Paciente.new()
      @paciente.persona_id = params[:paciente][:id]

        if @cliente.save

          auditoria_nueva("registrar paciente", "pacientes", @paciente)
         
          @guardado_ok = true
         
        end 

    end
  
    rescue Exception => exc  
    # dispone el mensaje de error 
    #puts "Aqui si muestra el error ".concat(exc.message)
      if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4].to_s)
      
      end                
              
  	respond_to do |f|
	    
	      f.js
	    
	end

  end

  def editar
    
    @paciente = Paciente.find(params[:id])

  	respond_to do |f|
	    
	      f.js
	    
	end

  end

  def actualizar

    valido = true
    @msg = ""
    @cliente = Cliente.find(params[:cliente_id])

    auditoria_id = auditoria_antes("actualizar cliente", "pacientes", @cliente)

    if valido

      @cliente.razon_social = params[:cliente][:razon_social].upcase
      @cliente.ruc = params[:cliente][:ruc]
      @cliente.cliente_nombre = params[:cliente][:cliente_nombre].upcase
      @cliente.cliente_apellido =  params[:cliente][:cliente_apellido].upcase
      @cliente.direccion = params[:cliente][:direccion].upcase
      @cliente.telefono = params[:cliente][:telefono]

      if @cliente.save

        auditoria_despues(@cliente, auditoria_id)
        @cliente_ok = true

      end

    end
        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4])
        end                

  	respond_to do |f|
	    
	      f.js
	    
	  end

  end

  def buscar_cliente
    
    @personas = Cliente.where("cliente_nombre ilike ?", "%#{params[:cliente_produccion]}%")

    respond_to do |f|
      
      f.html
      f.json { render :json => @personas }
    
    end
    
  end

  def eliminar

    valido = true
    @msg = ""

    @cliente = Cliente.find(params[:id])

    @cliente_elim = @cliente  

    if valido

      if @cliente.destroy

        auditoria_nueva("eliminar cliente", "pacientes", @cliente_elim)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el Cliente."

      end

    end
        rescue Exception => exc  
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4])
        @eliminado = false
        end
        
    respond_to do |f|

      f.js

    end

  end

end