module PacientesHelper

def link_to_editar_paciente(persona_id)

    render partial: 'link_to_editar_paciente', locals: { persona_id: persona_id }
    
end
  
end
