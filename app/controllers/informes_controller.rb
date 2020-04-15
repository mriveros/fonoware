class InformesController < ApplicationController

	before_filter :require_usuario

  def indexa

  	cond = []
    args = []

  	@informe = "informes"
  	@msg = "" 
    
    if params[:paciente_id].present?

      cond << "paciente_id = ?"
      args << params[:paciente_id]

    end

    if params[:profesional_id].present?

      cond << "profesional_id = ?"
      args << params[:profesional_id]

    end

    if params[:tipo_consulta][:id].present?

      cond << "tipo_consulta_id = ?"
      args << params[:tipo_consulta][:id]

    end

    if params[:estado_cita][:id].present?

      cond << "estado_cita_id = ?"
      args << params[:estado_cita][:id]

    end

    if params[:estado_cobro][:id].present?

      cond << "estado_cobro_id = ?"
      args << params[:estado_cobro][:id]

    end

    if params[:fecha_desde].present? && params[:fecha_hasta].present? 

      cond << "fecha_cita >= '#{params[:fecha_desde]}' and fecha_cita <= '#{params[:fecha_hasta]}'" 

    elsif params[:fecha_desde].present?
      
      cond << "fecha_cita >= ?"
      args << params[:fecha_desde]

    elsif params[:fecha_hasta].present?
      
      cond << "fecha_cita <= ?"
      args << params[:fecha_hasta]

    end


    cond = cond.join(" and ").lines.to_a + args if cond.size > 0

    if cond.size > 0
     
      @produccion =  VCita.where(cond).orden_01.paginate(per_page: 10, page: params[:page])

    else

      @produccion = VCita.orden_01.paginate(per_page: 10, page: params[:page])
     
    end

    @parametros = { format: :pdf, produccion_id: @produccion.map(&:produccion_id), flota_id: params[:flota_id], chofer_id: params[:chofer_id], cliente_id: params[:cliente_id], fecha_desde: params[:fecha_desde], fecha_hasta: params[:fecha_hasta], pertenece: params[:pertenece], cobrado: params[:cobrado], estado_produccion_id: params[:form_buscar_produccion][:estado_produccion_id] }

    respond_to do |f|

      f.js

    end

  end

  def generar_pdf
    
    
   @produccion =  VProduccion.where("produccion_id in (?)", params[:produccion_id]).orden_01.paginate(per_page: 10, page: params[:page])
    

    respond_to do |f|
     
      f.pdf do

          render  :pdf => "planilla_resumen_produccion_#{Time.now.strftime("%Y_%m_%d__%H_%M")}",
                  :template => 'informes/planilla_resumen_produccion.pdf.erb',
                  :layout => 'pdf.html',
                  :header => {:html => { :template => "informes/cabecera_planilla_resumen_produccion.pdf.erb" ,
                  :locals   => { :produccion => @produccion }}},
                  :margin => {:top => 65,                         # default 10 (mm)
                  :bottom => 11,
                  :left => 3,
                  :right => 3},
                  :orientation => 'Landscape',
                  :page_size => "A4",
                  :footer => { :html => {:template => 'layouts/footer.pdf' },
                  :spacing => 1,
                  :line => true }
      end
      
    end

  end

end


