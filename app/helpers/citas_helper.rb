module CitasHelper

  def link_to_editar_cita(cita)

      render partial: 'link_to_editar_cita', locals: { cita: cita }
      
  end

  
end