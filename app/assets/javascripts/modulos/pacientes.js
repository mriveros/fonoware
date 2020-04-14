//----------------------- ALERTA PARA FOMULARIOS ---------------//
function alerta_formulario(elemento, estado){
  
  if(estado){
  
    elemento.attr("style", "border:1px solid green;");
    elemento.parent().next().html("<span class='glyphicon glyphicon-ok' style='color:green;padding-top:20px;'></span>");
  
  }else{
 
    elemento.attr("style", "border:1px solid red;");
    elemento.parent().next().html("<span class='glyphicon glyphicon-remove' style='color:red;padding-top:20px;'></span>");

  }

}
//--------------------------------------------------------------//
// --------------------- BUSCAR PERSONA ------------------------//
function buscar_persona(tipo_documento_id, nacionalidad_id, documento, ruta){

  $("#msg-documento-persona").remove();

  $.ajax({
    type: 'GET',
    url: ruta,
    data: {tipo_documento_id: tipo_documento_id, nacionalidad_id: nacionalidad_id, documento:documento},
    success: function(data){
      
      if(data != null){
          
        $("#persona_documento").next();
        
        $("#persona_nombre").val(data.nombre_persona); 
        $("#persona_apellido").val(data.apellido_persona);
        $("#usuario_email").focus();
          
      }else{


        $("<span id='msg-documento-persona' style='color:red;padding-top:20px;font-size:10px;'>Esta persona no existe, comuniquese a rue@mec.gov.py adjuntando copia del documento de identidad para registrar la persona y habilitar la creación del usuario.</span>").insertAfter("#persona_documento");

        $("#persona_nombre").val('');
        $("#persona_apellido").val('');
          
      }
    },
    typeData: 'json'     
  })
}
//--------------------------------------------------------//
// --------------------- BUSCAR PERSONA ------------------------//
function buscar_persona_v2(tipo_documento_id, nacionalidad_id, documento, ruta, ruta_agregar_persona){

  $("#msg-documento-persona").remove();
  $('#buscar_perso').html('');
  $.ajax({
    type: 'GET',
    url: ruta,
    data: {tipo_documento_id: tipo_documento_id, nacionalidad_id: nacionalidad_id, documento:documento},
    success: function(data){
      
      if(data != null){
          
        $("#persona_documento").next();
        
        $("#persona_nombre").val(data.nombre_persona); 
        $("#persona_apellido").val(data.apellido_persona);
        $("#usuario_password").val(data.documento_persona);
        $("#usuario_password_confirmation").val(data.documento_persona);
        $("#persona_id").val(data.id);
        $("#usuario_email").focus();
          
      }else{
        $('#buscar_perso').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-info-sign"></span>\n\
        Esta persona no existe, debe registrar previamente la persona para la creación de pacientes, corroborando previamente con copia del documento.\n\
        <a href="' + ruta_agregar_persona + '" class="btn btn-primary btn-xs" target="_blank" style="margin-left:10px;">Agregar Persona</a></div>');
        /*$("<span id='msg-documento-persona' style='color:red;font-size:10px;margin: 10px 0 0 10px;'>Esta persona no existe, debe registrar previamente la persona para la creación de usuarios, corroborando previamente con copia del documento.<a href='" + ruta_agregar_persona + "' class='btn btn-primary btn-xs' target='_blank' style='margin-left:10px;'>Agregar Persona</a></span>").insertAfter("#persona_documento");*/

        $("#persona_nombre").val('');
        $("#persona_apellido").val('');
        $("#usuario_password").val('');
        $("#usuario_password_confirmation").val('');
          
      }
    },
    typeData: 'json'     
  })
}

// --------------------- BUSCAR PACIENTE ------------------------//
function buscar_paciente(tipo_documento_id, nacionalidad_id, documento, ruta, ruta_agregar_persona){

  $("#msg-documento-persona").remove();
  $('#buscar_perso').html('');
  $.ajax({
    type: 'GET',
    url: ruta,
    data: {tipo_documento_id: tipo_documento_id, nacionalidad_id: nacionalidad_id, documento:documento},
    success: function(data){
      
      if(data != null){
          
        $("#persona_documento").next();
        $("#persona_nombre").val(data.nombre_persona); 
        $("#persona_apellido").val(data.apellido_persona);
        $("#paciente_id").val(data.paciente_id);
        
          
      }else{
        $('#buscar_perso').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-info-sign"></span>\n\
        El paciente no existe, debe registrar previamente la persona para la creación de pacientes, corroborando previamente con copia del documento.\n\
        <a href="' + ruta_agregar_persona + '" class="btn btn-primary btn-xs" target="_blank" style="margin-left:10px;">Agregar Paciente</a></div>');
  
        $("#persona_nombre").val('');
        $("#persona_apellido").val('');
          
      }
    },
    typeData: 'json'     
  })
}

// --------------------- BUSCAR PACIENTE DOCUMENTO------------------------//
function buscar_paciente_documento(documento, ruta, ruta_agregar_persona){

  $("#msg-documento-persona").remove();
  $('#buscar_perso').html('');
  $.ajax({
    type: 'GET',
    url: ruta,
    data: { documento:documento},
    success: function(data){
      
      if(data != null){
          
        $("#persona_documento").next();
        $("#persona_nombre").val(data.nombre_persona); 
        $("#persona_apellido").val(data.apellido_persona);
        $("#paciente_id").val(data.paciente_id);
        
          
      }else{
        $('#buscar_perso').html('<div class="alert alert-danger"><span class="glyphicon glyphicon-info-sign"></span>\n\
        El paciente no existe, debe registrar previamente la persona para la creación de pacientes, corroborando previamente con copia del documento.\n\
        <a href="' + ruta_agregar_persona + '" class="btn btn-primary btn-xs" target="_blank" style="margin-left:10px;">Agregar Paciente</a></div>');
  
        $("#persona_nombre").val('');
        $("#persona_apellido").val('');
          
      }
    },
    typeData: 'json'     
  })
}

//--------------------------------------------------------//
// --------------------- BUSCAR USUARIO ------------------------//
function buscar_usuario(tipo_documento_id, nacionalidad_id, documento, fecha_nacimiento, ruta){

  $("#msg-documento-persona").remove();

  $.ajax({
    type: 'GET',
    url: ruta,
    data: {tipo_documento_id: tipo_documento_id, nacionalidad_id: nacionalidad_id, documento:documento, fecha_nacimiento: fecha_nacimiento},
    success: function(data){
      
      if(data != null){
          
        $("#persona_documento").next();
        
        $("#persona_nombre").val(data.nombre_persona); 
        $("#persona_apellido").val(data.apellido_persona);
        $("#usuario_email").val(data.usuario_email);

          
      }else{


        $("<span id='msg-documento-persona' style='color:red;padding-top:20px;font-size:10px;'>Usuario no encontrado.</span>").insertAfter("#persona_documento");

        $("#persona_nombre").val('');
        $("#persona_apellido").val('');
        $("#usuario_email").val('');
          
      }
    },
    typeData: 'json'     
  })
}