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

end