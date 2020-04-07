class PacientesController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index
  

  end
 
  def lista

    cond = []
    args = []

    if params[:form_buscar_pacientes_id].present?

      cond << "paciente_id = ?"
      args << params[:form_buscar_pacientes_id]

    end

    if params[:form_buscar_paciente_documento].present?

      cond << "documento_persona = ?"
      args << params[:form_buscar_paciente_documento]

    end

    if params[:form_buscar_pacientes_nombre].present?

      cond << "nombre_persona ilike ?"
      args << "%#{params[:form_buscar_pacientes_nombre]}%"

    end

    if params[:form_buscar_pacientes_apellido].present?

      cond << "apellido_persona ilike ?"
      args << "%#{params[:form_buscar_pacientes_apellido]}%"

    end

    if params[:form_buscar_pacientes_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_pacientes_direccion]}%"

    end

    if params[:form_buscar_pacientes_telefono].present?

      cond << "telefono ilike ?"
      args << "%#{params[:form_buscar_pacientes_telefono]}%"

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

    @paciente = VPaciente.new

    respond_to do |f|
	    
	      f.js
	    
	  end

  end

  def guardar

    @valido = true
    @msg = ""
    @guardado_ok = false

    unless params[:persona_documento].present?

      @valido = false
      @msg += " Debe Completar el campo Documento. \n"

    end

    if @valido
      
      @paciente = Paciente.new()
      @paciente.persona_id = params[:persona_id]

        if @paciente.save

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
    
    @paciente = Persona.find(params[:id])

  	respond_to do |f|
	    
	      f.js
	    
	end

  end

  def actualizar

    valido = true
    @msg = ""

    @persona = Persona.find(params[:persona][:id])
    @paciente = Paciente.where("persona_id = ?", params[:persona][:id]).first
    auditoria_id = auditoria_antes("actualizar persona", "personas", @persona)

    if valido

      @persona.update_attributes(params[:persona] )
      auditoria_despues(@persona, auditoria_id)

      if @persona.save

        @persona_ok = true

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

  def buscar_paciente
    
    @personas = VPaciente.where("nombre_persona ilike ?", "%#{params[:cliente_produccion]}%")

    respond_to do |f|
      
      f.html
      f.json { render :json => @personas }
    
    end
    
  end

  def eliminar

    @valido = true
    @msg = ""

    @paciente = Paciente.find(params[:id])
    @paciente_detalle  = PacienteDetalleFono.where("paciente_id = ?", params[:id]).first

    @paciente_elim = @paciente  

    if @valido

      if @paciente_detalle.destroy
        
        auditoria_nueva("eliminar cliente detalle", "pacientes_detalles_fono", @paciente_detalle)
        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el Detalle del Paciente."

      end

      if @paciente.destroy

        auditoria_nueva("eliminar cliente", "pacientes", @paciente)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el Paciente."

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


  def buscar_persona
    
    if params[:tipo_documento_id].present? && params[:nacionalidad_id] && params[:documento].present?

      @persona = Persona.where("tipo_documento_id = ? and nacionalidad_id = ? and documento_persona = ?", params[:tipo_documento_id], params[:nacionalidad_id], params[:documento])  
 
    end

    respond_to do |f|

      f.json { render :json => @persona.first}

    end

  end



  def paciente_detalle_fono

    @paciente = Paciente.where("id = ?", params[:paciente_id]).first
    @paciente_detalle_fono = PacienteDetalleFono.where("paciente_id = ?", params[:paciente_id]).first

    respond_to do |f|

      f.js

    end
    
  end


  def guardar_detalle_fono

    @valido = true
    guardado_ok = false

    @paciente = Paciente.where("id = ?", params[:paciente_id]).first

    @paciente_detalle_fono = PacienteDetalleFono.where("paciente_id = ?", params[:paciente_id]).first

    if @paciente_detalle_fono.present?

      auditoria_id = auditoria_antes("actualizar datos de detalles de pacientes", "pacientes_detalles_fono", @paciente_detalle_fono)
      @paciente_detalle_fono.antecedentes_personales = params[:antecedentes_personales]
      @paciente_detalle_fono.antecedentes_familiares = params[:antecedentes_familiares]
      @paciente_detalle_fono.antecedentes_otros = params[:antecedentes_otros]
      @paciente_detalle_fono.antecedentes_habitos = params[:antecedentes_habitos]
      @paciente_detalle_fono.sindrome = params[:sindrome]
      @paciente_detalle_fono.sindrome_especificar = params[:sindrome_especificar]
      @paciente_detalle_fono.transtornos = params[:transtornos]
      @paciente_detalle_fono.transtorno_especificar = params[:transtorno_especificar]
      @paciente_detalle_fono.enfermedad = params[:enfermedad]
      @paciente_detalle_fono.enfermedad_especificar = params[:enfermedad_especificar]
      @paciente_detalle_fono.escolaridad_grado_id = params[:escolaridad_grado][:id]
      @paciente_detalle_fono.escolaridad_tiempo = params[:escolaridad_tiempo]
      @paciente_detalle_fono.escolaridad_institucion = params[:escolaridad_institucion]
      @paciente_detalle_fono.datos_derivacion = params[:datos_derivacion]
      
      if @paciente_detalle_fono.save

        @guardado_ok = true
        auditoria_despues(@paciente_detalle_fono, auditoria_id)

      end

    else

      @paciente_detalle_fono = PacienteDetalleFono.new
      @paciente_detalle_fono.paciente_id = params[:paciente_id]
      @paciente_detalle_fono.antecedentes_personales = params[:antecedentes_personales]
      @paciente_detalle_fono.antecedentes_familiares = params[:antecedentes_familiares]
      @paciente_detalle_fono.antecedentes_otros = params[:antecedentes_otros]
      @paciente_detalle_fono.antecedentes_habitos = params[:antecedentes_habitos]
      @paciente_detalle_fono.sindrome = params[:sindrome]
      @paciente_detalle_fono.sindrome_especificar = params[:sindrome_especificar]
      @paciente_detalle_fono.transtornos = params[:transtornos]
      @paciente_detalle_fono.transtorno_especificar = params[:transtorno_especificar]
      @paciente_detalle_fono.enfermedad = params[:enfermedad]
      @paciente_detalle_fono.enfermedad_especificar = params[:enfermedad_especificar]
      @paciente_detalle_fono.escolaridad_grado_id = params[:escolaridad_grado][:id]
      @paciente_detalle_fono.escolaridad_tiempo = params[:escolaridad_tiempo]
      @paciente_detalle_fono.escolaridad_institucion = params[:escolaridad_institucion]
      @paciente_detalle_fono.datos_derivacion = params[:datos_derivacion]
      
      if @paciente_detalle_fono.save

        @guardado_ok = true
        auditoria_nueva("registrar paciente detalle fono", "pacientes_detalles_fono", @paciente_detalle_fono)

      end

    end

    respond_to do |f|

      f.js

    end
    
  end

end