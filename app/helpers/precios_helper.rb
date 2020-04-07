module PreciosHelper

def link_to_editar_precio(precio)

    render partial: 'link_to_editar_precio', locals: { precio: precio }
    
end
  
end
