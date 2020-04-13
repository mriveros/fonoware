class CitasDetallesFonoController < ApplicationController

before_filter :require_usuario

  def index

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