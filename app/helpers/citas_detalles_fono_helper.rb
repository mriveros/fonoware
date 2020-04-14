module CitasDetallesFonoHelper

  def link_to_emitir_resolucion(cita_id)

      render partial: 'link_to_emitir_resolucion', locals: { cita_id: cita_id }
      
  end

  def link_to_adjuntar_resolucion(cita_detalle_id)

      @cita_detalle_fono = CitaDetalleFono.where("id = ?", cita_detalle_id).first
      render partial: 'link_to_adjuntar_resolucion', locals: { cita_detalle_id: @cita_detalle_fono.id, resolucion_id: @cita_detalle_fono.resolucion_id, cita_id: @cita_detalle_fono.cita_id }
      
  end

  

  
end