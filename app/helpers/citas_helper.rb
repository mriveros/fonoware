module CitasHelper

  def link_to_editar_cita(cita)

      render partial: 'link_to_editar_cita', locals: { cita: cita }
      
  end

  def link_to_cita_detalle_fono(cita_id)

    render partial: 'link_to_cita_detalle_fono', locals: { cita_id: cita_id}

  end

  def link_to_cita_detalle_fono_terminado(cita_id)

    render partial: 'link_to_cita_detalle_fono_terminado', locals: { cita_id: cita_id}

  end

  
end