module PacientesHelper

def link_to_editar_paciente(persona_id)

    render partial: 'link_to_editar_paciente', locals: { persona_id: persona_id }
    
end


def link_to_paciente_detalle_fono(paciente_id)

  render partial: 'link_to_paciente_detalle_fono', locals: { paciente_id: paciente_id}

end
  
end
