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

    if params[:form_buscar_citas][:estado_cobro_id].present?

      cond << "estado_cobro_id = ?"
      args << params[:form_buscar_citas][:estado_cobro_id]

    end

    if rol_tutor
       
      tutor = Tutor.where("persona_id = ?", current_usuario.persona_id).first
      tutor_detalle = TutorDetalle.where("tutor_id = ?", tutor.id)
      
      cond << "paciente_id in (?)"
      args << tutor_detalle.map(&:paciente_id)
      
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

    @valido = true
    @msg = ""
    @cita_ok = false
    

    if @valido

      @cita = Cita.new()
      @cita.fecha_cita = params[:fecha_cita]
      @cita.paciente_id = params[:paciente_id]
      @cita.profesional_id = params[:profesional_id]
      @cita.tipo_consulta_id = params[:cita][:tipo_consulta_id]
      @cita.precio_id = params[:cita][:precio_id]
      @cita.especialidad_id = PARAMETRO[:especialidad_fonoaudiologia]
      @cita.observacion = params[:observacion] 
      @cita.estado_cita_id = PARAMETRO[:estado_cita_en_espera]
      @cita.estado_cobro_id = PARAMETRO[:estado_cobro_pendiente]
      if @cita.save

        auditoria_nueva("registrar cita", "citas", @cita)   
        @cita_ok = true

      else

        @msg = "Error al guardar la cita. Intente más tarde"

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

    @cita = VCita.where("cita_id = ?", params[:id]).first

    respond_to do |f|

      f.js

    end

  end

  def actualizar

    @valido = true
    @msg = ""
    @cita_ok = false

    @cita = Cita.find(params[:cita_id])
    auditoria_id = auditoria_antes("actualizar cita", "citas", @cita)

    if @valido

      @cita.fecha_cita = params[:fecha_cita]
      @cita.paciente_id = params[:paciente_id]
      @cita.profesional_id = params[:profesional_id]
      @cita.tipo_consulta_id = params[:v_cita][:tipo_consulta_id]
      @cita.precio_id = params[:v_cita][:precio_id]
      @cita.especialidad_id = PARAMETRO[:especialidad_fonoaudiologia]
      @cita.observacion = params[:observacion] 
      @cita.estado_cita_id = PARAMETRO[:estado_cita_en_espera]
      if @cita.save

        auditoria_nueva("registrar cita", "citas", @cita)   
        @cita_ok = true

      else

        @msg = "Error al actualizar la cita. Intente más tarde"

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
    @cita_detalle = CitaDetalleFono.where("cita_id = ?", params[:id]).first

    @cita_elim = @cita  

    if @valido
      
      if @cita_detalle.present?

        @cita_detalle.destroy

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


  def cambiar_estado_cita_en_espera_a_en_consultorio

    @msg = ""
    @actualizado = false
    
    @cita = Cita.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("cambiar estado cita de en espera a en consultorio ", "citas", @cita)

    if @cita.present?

      @cita.estado_cita_id = PARAMETRO[:estado_cita_en_consultorio]

      if @cita.save
      
        @msg = "Estado de la Cita modificado exitosamente!"
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

  def cambiar_estado_cita_en_consultorio_a_en_espera

    @msg = ""
    @actualizado = false
    
    @cita = Cita.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("cambiar estado cita de en consultorio a en espera ", "citas", @cita)

    if @cita.present?

      @cita.estado_cita_id = PARAMETRO[:estado_cita_en_espera]

      if @cita.save
      
        @msg = "Estado de la Cita modificado exitosamente!"
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


  def cambiar_estado_cita_en_consultorio_a_terminado

    @msg = ""
    @actualizado = false
    
    @cita = Cita.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("cambiar estado cita de en consultorio a terminado", "citas", @cita)

    if @cita.present?

      @cita.estado_cita_id = PARAMETRO[:estado_cita_terminado]

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

  
  def cambiar_estado_cobro_a_cobrado

    @msg = ""
    @actualizado = false
    
    @cita = Cita.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("cambiar estado de cobro de cita a cobrado", "citas", @cita)

    if @cita.present?

      @cita.estado_cobro_id = PARAMETRO[:estado_cobro_cobrado]

      if @cita.save
      
        @msg = "La Cita ha sido marcado como Cobrado exitosamente!"
        @actualizado = true
        auditoria_despues(@cita, auditoria_id)

      end

    else

      @msg = "No se pudo realizar la modificación del estado de cobro de la Cita. Intente más tarde."

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

  def cambiar_estado_cobro_a_no_cobrado

    @msg = ""
    @actualizado = false
    
    @cita = Cita.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("cambiar estado de cobro de cita a cobrado", "citas", @cita)

    if @cita.present?

      @cita.estado_cobro_id = PARAMETRO[:estado_cobro_no_cobrado]

      if @cita.save
      
        @msg = "La Cita ha sido marcado como No Cobrado"
        @actualizado = true
        auditoria_despues(@cita, auditoria_id)

      end

    else

      @msg = "No se pudo realizar la modificación del estado de cobro de la Cita. Intente más tarde."

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

  def cambiar_estado_cita_terminado_a_en_consultorio

    @msg = ""
    @actualizado = false
    
    @cita = Cita.where("id = ?", params[:id]).first
    auditoria_id = auditoria_antes("cambiar estado cita de terminado a en consultorio", "citas", @cita)

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

  
  def postergar_cita

    @cita = Cita.where("id = ?", params[:cita_id]).first

    respond_to do |f|

      f.js
      
    end

  end


  def guardar_postergar_cita
    
    @cita_ok = false
    @msg = ""

    @cita = Cita.where("id = ?", params[:cita_id]).first
    @cita.observacion = "FECHA ORIGINAL: #{@cita.fecha_cita}, FECHA POSTERGACION: #{params[:fecha_cita]} OBS: #{params[:observacion]}"
    @cita.fecha_cita = params[:fecha_cita]
    @cita.estado_cita_id = PARAMETRO[:estado_cita_postergado]

    if @cita.save

      @cita_ok = true

    else

      @msg = "No se pudo reagendar la cita. Intente más tarde. "

    end

    respond_to do |f|

      f.js
      
    end

  end

  def imprimir_informe

    @cita = VCita.where("cita_id = ?", params[:id]).first

    @parametros = { format: :pdf, cita_id: @cita.cita_id }

    respond_to do |f|

      f.js

    end

  end


  def generar_informe_pdf

    @cita =  VCita.where("cita_id = ?", params[:cita_id]).first
    
    respond_to do |f|
     
      f.pdf do

          render  :pdf => "informe_cita_#{Time.now.strftime("%Y_%m_%d__%H_%M")}",
                  :template => 'citas/planilla_reporte_cita.pdf.erb',
                  :layout => 'pdf.html',
                  :header => {:html => { :template => "citas/cabecera_planilla_resumen_cita.pdf.erb" ,
                  :locals   => { :cita => @cita }}},
                  :margin => {:top => 65,                         # default 10 (mm)
                  :bottom => 11,
                  :left => 3,
                  :right => 3},
                  :orientation => 'Portrait',
                  :page_size => "A4",
                  :footer => { :html => {:template => 'layouts/footer.pdf' },
                  :spacing => 1,
                  :line => true }
      end
      
    end

  end

end