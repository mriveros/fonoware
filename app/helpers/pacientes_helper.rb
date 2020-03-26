module PacientesHelper

def link_to_editar_paciente(paciente)

    render partial: 'link_to_editar_paciente', locals: { paciente: paciente }
    
end
  
end
