class CitasController < ApplicationController

before_filter :require_usuario

  def index

  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_citas_id].present?

      cond << "cita_id = ?"
      args << params[:form_buscar_citas_id]

    end

    if params[:form_buscar_citas_fecha].present?

      cond << "fecha_cita = ?"
      args << params[:form_buscar_citas_fecha]

    end

    if params[:form_buscar_citas_paciente_documento].present?

      cond << "paciente_documento = ?"
      args << params[:form_buscar_citas_paciente_documento]

    end

    if params[:form_buscar_citas_pacientes_nombre].present?

      cond << "paciente_nombre ilike ?"
      args << "%#{params[:form_buscar_citas_pacientes_nombre]}%"

    end

    if params[:form_buscar_citas_pacientes_apellido].present?

      cond << "paciente_apellido ilike ?"
      args << "%#{params[:form_buscar_citas_pacientes_apellido]}%"

    end

    if params[:form_buscar_citas][:tipo_consulta_id].present?

      cond << "tipo_consulta_id = ?"
      args << params[:form_buscar_citas][:tipo_consulta_id]

    end

    if params[:form_buscar_citas_monto_consulta].present?

      cond << "precio = ?"
      args << params[:form_buscar_citas_monto_consulta]

    end

    if params[:form_buscar_citas][:estado_cita_id].present?

      cond << "estado_cita_id = ?"
      args << params[:form_buscar_citas][:estado_cita_id]

    end


    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @citas =  VCita.orden_fecha_cita.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VCita.where(cond).count

    else

      @citas = VCita.orden_fecha_cita.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VCita.count

    end

    @total_registros = VCita.count

    respond_to do |f|

      f.js

    end

  end

  def agregar

    @cita = Cita.new

    respond_to do |f|

      f.js
      
    end

  end

  def guardar

    valido = true
    @msg = ""
    @cita_ok = false

    @cita = Cita.new()
    @cita.fecha_cita = params[:cita][:fecha]
    @cita.paciente_id = params[:paciente_id]
    @cita.profesional_id = params[:profesional_id]
    @cita.tipo_consulta_id = params[:tipo_consulta][:id]
    @cita.especialidad_id = PARAMETROS[:especialidad_fonoaudiologia]
    @cita.precio_id = params[:precio_id]
    @cita.observacion = params[:cita][:observacion]
    @cita.paciente_id = params[:paciente_id]    

    if @cita.save

      auditoria_nueva("registrar cita", "citas", @cita)   
      @cita_ok = true
    
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

    @cita = Cita.find(params[:id])

    respond_to do |f|

      f.js

    end

  end

  def actualizar

    valido = true
    @msg = ""

    @cita = Cita.find(params[:cita][:id])
    auditoria_id = auditoria_antes("actualizar cita", "citas", @cita)

    if valido

      @cita.fecha_cita = params[:cita][:fecha]
      @cita.paciente_id = params[:paciente_id]
      @cita.profesional_id = params[:profesional_id]
      @cita.tipo_consulta_id = params[:tipo_consulta][:id]
      @cita.especialidad_id = PARAMETROS[:especialidad_fonoaudiologia]
      @cita.precio_id = params[:precio_id]
      @cita.observacion = params[:cita][:observacion]
      @cita.paciente_id = params[:paciente_id]
     

      if @cita.save

        auditoria_despues(@cita, auditoria_id)
        @cita_ok = true

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
  
  def eliminar

    @valido = true
    @msg = ""

    @cita = Cita.find(params[:id])
    @cita_elim = @cita  

    if @valido

      if @cita.destroy

        auditoria_nueva("eliminar cita", "citas", @cita)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar la Cita."

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


  def cambiar_estado_cita_en_espera_a_en_consultorio

    @msg = ""
    @actualizado = false
    
    @cita = Cita.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("cambiar estado cita de en espera a en consultorio ", "citas", @cita)

    if @cita.present?

      @cita.estado_cita_id = PARAMETRO[:estado_cita_en_consultorio]

      if @cita.save
      
        @msg = "El estado de la Cita modificado exitosamente!"
        @actualizado = true
        auditoria_despues(@cita, auditoria_id)

      end

    else

      @msg = "No se pudo realizar la modificación del estado de la Cita. Intente más tarde."

    end
    
    rescue Exception => exc  
        
        # dispone el mensaje de error 
        #puts "Aqui si muestra el error ".concat(exc.message)
        if exc.present?        
        @excep = exc.message.split(':')    
        @msg = @excep[3].concat( " " + @excep[4].to_s)
        @eliminado = false
        
    end



     respond_to do |f|

      f.js

    end

  end


  def cita_detalle_fono

    @cita = Cita.where("id = ?", params[:cita_id]).first
    @cita_detalle_fono = nil

    respond_to do |f|

      f.js

    end

  end

  def guardar_cita_detalle_fono


    respond_to do |f|

      f.js

    end

  end

end