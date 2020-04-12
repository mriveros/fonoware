class CitasController < ApplicationController

before_filter :require_usuario

  def index

  end

  def lista

    cond = []
    args = []

    if params[:form_buscar_citas_id].present?

      cond << "paciente_id = ?"
      args << params[:form_buscar_citas_id]

    end

    if params[:form_buscar_citas_fecha].present?

      cond << "fecha_cita = ?"
      args << params[:form_buscar_citas_fecha]

    end

    if params[:form_buscar_citas_paciente_documento].present?

      cond << "documento_persona = ?"
      args << params[:form_buscar_citas_paciente_documento]

    end

    if params[:form_buscar_citas_pacientes_nombre].present?

      cond << "nombre_persona ilike ?"
      args << "%#{params[:form_buscar_citas_pacientes_nombre]}%"

    end

    if params[:form_buscar_citas_pacientes_apellido].present?

      cond << "apellido_persona ilike ?"
      args << "%#{params[:form_buscar_citas_pacientes_apellido]}%"

    end

    if params[:form_buscar_citas_tipo_consulta].present?

      cond << "tipo_consulta = ?"
      args << params[:form_buscar_citas_tipo_consulta]

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
    #@cita_detalle  = CitaDetalleFono.where("cita_id = ?", params[:id]).first
    @cita_elim = @cita  

    if @valido

      if @cita_detalle.present?

        #OBS: en este codigo incluiremos validaciones de que tipo de usuario quiere eliminar una
        # cita, si es administrador puede hacerlo si tiene detalles de citas.
        #if @cita_detalle.destroy
          
        #  auditoria_nueva("eliminar cita detalle", "citas_detalles_fono", @cita_detalle)
        #  @eliminado = true

        #else

        #  @msg = "ERROR: No se ha podido eliminar la cita del Paciente."

        #end

      end

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

end