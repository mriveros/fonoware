class ProfesionalesController < ApplicationController

before_filter :require_usuario
skip_before_action :verify_authenticity_token

  def index
  

  end
 
  def lista

    cond = []
    args = []

    if params[:form_buscar_profesional_id].present?

      cond << "profesional_id = ?"
      args << params[:form_buscar_profesional_id]

    end

    if params[:form_buscar_profesional_documento].present?

      cond << "documento_persona = ?"
      args << params[:form_buscar_profesional_documento]

    end

    if params[:form_buscar_profesional_nombre].present?

      cond << "nombre_persona ilike ?"
      args << "%#{params[:form_buscar_profesional_nombre]}%"

    end

    if params[:form_buscar_profesional_apellido].present?

      cond << "apellido_persona ilike ?"
      args << "%#{params[:form_buscar_profesional_apellido]}%"

    end

    if params[:form_buscar_profesional_direccion].present?

      cond << "direccion ilike ?"
      args << "%#{params[:form_buscar_profesional_direccion]}%"

    end

    if params[:form_buscar_profesional_telefono].present?

      cond << "telefono ilike ?"
      args << "%#{params[:form_buscar_profesional_telefono]}%"

    end

    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0

      @profesional =  VProfesional.orden_01.where(cond).paginate(per_page: 10, page: params[:page])
      @total_encontrados = VProfesional.where(cond).count

    else

      @profesional = VProfesional.orden_01.paginate(per_page: 10, page: params[:page])
      @total_encontrados = VProfesional.count

    end

    @total_registros = VProfesional.count

    respond_to do |f|
      
     f.js
      
    end

  end

  def agregar

    @profesional = VProfesional.new

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
      
      @profesional = Profesional.new()
      @profesional.persona_id = params[:persona_id]

        if @profesional.save

          auditoria_nueva("registrar profesional", "profesional", @profesional)
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
    
    @profesional = Persona.find(params[:id])

    respond_to do |f|
      
        f.js
      
  end

  end

  def actualizar

    valido = true
    @msg = ""

    @persona = Persona.find(params[:persona][:id])
    @profesional = Profesonal.where("persona_id = ?", params[:persona][:id]).first
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

  def buscar_profesional
    
    @personas = VProfesional.where("nombre_persona ilike ?", "%#{params[:cliente_produccion]}%")

    respond_to do |f|
      
      f.html
      f.json { render :json => @personas }
    
    end
    
  end

  def eliminar

    @valido = true
    @msg = ""

    @profesional = Profesional.find(params[:id])

    @profesional_elim = @profesional  

    if @valido

      if @profesional.destroy

        auditoria_nueva("eliminar cliente", "profesionales", @profesional)

        @eliminado = true

      else

        @msg = "ERROR: No se ha podido eliminar el profesional."

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




 
    
  end

end