class CitasDetallesFonoController < ApplicationController

  before_filter :require_usuario


  def index

  end

  def cita_detalle_fono

    @cita = Cita.where("id = ?", params[:cita_id]).first
    @cita_detalle_fono = CitaDetalleFono.where("cita_id = ?", params[:cita_id]).first
    
    respond_to do |f|

      f.js

    end

  end


  def guardar_cita_detalle_fono

      @valido = true
      guardado_ok = false

      @cita = Cita.where("id = ?", params[:cita_id]).first

      @cita_detalle_fono = CitaDetalleFono.where("cita_id = ?", params[:cita_id]).first

      if @cita_detalle_fono.present?

        auditoria_id = auditoria_antes("actualizar datos de la cita detalle fono", "citas_detalles_fono", @cita_detalle_fono)
        @cita_detalle_fono.cita_id = params[:cita_id]
        @cita_detalle_fono.objetivo = params[:objetivo]
        @cita_detalle_fono.estrategia = params[:estrategia]
        @cita_detalle_fono.resultado = params[:resultado]
        @cita_detalle_fono.observacion = params[:observacion]
        
        if @cita_detalle_fono.save

          @guardado_ok = true
          auditoria_despues(@cita_detalle_fono, auditoria_id)

        end

      else

        @cita_detalle_fono = CitaDetalleFono.new
        @cita_detalle_fono.cita_id = params[:cita_id]
        @cita_detalle_fono.objetivo = params[:objetivo]
        @cita_detalle_fono.estrategia = params[:estrategia]
        @cita_detalle_fono.resultado = params[:resultado]
        @cita_detalle_fono.observacion = params[:observacion]
        
        if @cita_detalle_fono.save

          @guardado_ok = true
          auditoria_nueva("registrar detalles de la cita fonoaudiologica", "citas_detalles_fono", @cita_detalle_fono)

        end

      end

      respond_to do |f|

        f.js

      end

    end

  def emitir_resolucion

    @cita_detalle_fono = CitaDetalleFono.where("cita_id = ?", params[:cita_id]).first
    @resolucion = Resolucion.new

    respond_to do |f|

      f.js

    end    

  end

  def guardar_resolucion

    @valido = true    
    @msg = ""
    
    @resolucion = Resolucion.new(params[:resolucion])

    unless @resolucion.numero.present?

      @valido = false
      @msg += "Debe indicar el numero de la resolucion. \n"

    end

    unless @resolucion.descripcion.present?

      @valido = false
      @msg += "Debe ingresar una descripcion a la resolucion. \n"

    end

    if @resolucion.fecha_emision.present?

      fecha_emision = Date.parse(@resolucion.fecha_emision.to_s)
      
      fecha_actual =  Time.now     
     
      if fecha_emision > fecha_actual

        @valido = false
        @msg += "La fecha de la resolucion debe ser menor o igual a la fecha actual.\n"

      else

      end

    else

      @valido = false
      @msg += "Seleccione la fecha de resolucion.\n"

    end   

    if @valido

     
      @cita_detalle_fono = CitaDetalleFono.where("id = ? and resolucion_id is null", params[:resolucion][:cita_detalle_id]).first

      if @cita_detalle_fono.present?

        @resolucion.tipo_resolucion_id = PARAMETRO[:archivo_fonoaudiologico]
        
                              
        if @resolucion.save
      
          auditoria_nueva("registrar archivo de citas detalles fono", "resolucion", @resolucion)
          
          auditoria_id = auditoria_antes("Agregar archivo en citas detalles fono", 'citas_detalles_fono', @cita_detalle_fono)

          @cita_detalle_fono.resolucion_id = @resolucion.id
            
          if @cita_detalle_fono.save

            auditoria_despues(@cita_detalle_fono, auditoria_id)

          end          
                    
        end
 
      else
         
        @valido = false
        @msg += "La Cita ya posee un archivo o no se encontraron datos del proceso. Favor Verifique. \n"

      end

    end 

  rescue Exception => exc  
    
    # dispone el mensaje de error 
    #puts "Aqui si muestra el error ".concat(exc.message) 
       
    if exc.present?   

      @excep = exc.message.split(':')    
      @msg = @excep[3].concat(" "+@excep[4])
      @valido = false  

    end

    respond_to do |f|

      f.js

    end     

  end

  def adjuntar_resolucion

    @cita_detalle_fono = CitaDetalleFono.where("id = ?", params[:cita_detalle_id]).first
    @resolucion = Resolucion.find(params[:resolucion_id])

    respond_to do |f|

      f.js

    end    
  end 

  def guardar_resolucion_adjunta

    @valido = true    
    @msg = ""
    
    @cita_detalle_fono = CitaDetalleFono.where("id = ?", params[:cita_detalle_fono_id]).first
    
    unless params[:resolucion][:data].present?

      @valido = false
      @msg += "Debe adjuntar un documento PDF."

    end    
   
    if @valido

      @resolucion = Resolucion.find(params[:resolucion][:id])
      auditoria_id = auditoria_antes("adjuntar archivo de citas detalles fono", "resoluciones", @resolucion)
      @resolucion.update_attributes(params[:resolucion])

                              
      if @resolucion.save
        
        auditoria_despues(@resolucion, auditoria_id)         
        
      end

    end

    rescue Exception => exc  
      # dispone el mensaje de error 
      #puts "Aqui si muestra el error ".concat(exc.message) 
         
      if exc.present?    

        @excep = exc.message.split(':')    
        @msg = @excep[3].concat(" "+@excep[4])
        @valido = false  

      end

      respond_to do |f|

        f.js

      end     

  end


  def habilitar_descarga_archivo

    @valido = false
    @msg = ""

    cita_detalle_fono = CitaDetalleFono.where("id = ?", params[:cita_detalle_id]).first

    @resolucion = Resolucion.where("id = ?", cita_detalle_fono.resolucion_id).first
    auditoria_id = auditoria_antes("habilitar descarga de archivos", "resoluciones", @resolucion)
    @resolucion.habilitado = true

    if @resolucion.save

      @valido = true
      auditoria_despues(@resolucion, auditoria_id)

    end

    respond_to do |f|

        f.js

      end  


  end




end