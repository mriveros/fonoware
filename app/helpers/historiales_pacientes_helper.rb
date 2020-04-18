module HistorialesPacientesHelper

  def link_to_historial_paciente_detalle_fono(paciente_id)

    render partial: 'link_to_historial_paciente_detalle_fono', locals: { paciente_id: paciente_id}

  end

  def verificar_sindrome(paciente_id)

    @paciente_detalle_fono = PacienteDetalleFono.where("paciente_id = ?", paciente_id).first
    if @paciente_detalle_fono.present?
    
      return (@paciente_detalle_fono.sindrome.present?)? true : false

    end

  end

  def verificar_transtorno(paciente_id)

    @paciente_detalle_fono = PacienteDetalleFono.where("paciente_id = ?", paciente_id).first
    if @paciente_detalle_fono.present?

      return (@paciente_detalle_fono.transtornos.present?)? true : false
    
    end

  end

  def verificar_enfermedad(paciente_id)

    @paciente_detalle_fono = PacienteDetalleFono.where("paciente_id = ?", paciente_id).first
    if @paciente_detalle_fono.present?

      return (@paciente_detalle_fono.enfermedad.present?)? true : false
    
    end

  end
  
end