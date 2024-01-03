module ApplicationHelper
  def ranks_short #Pakāpju īsie nosaukumi
    ["MZSK/GNT", "SK/G", "DZSK/DZG", "ROV/LG", "VAD", "VIEDSK/VIEDG", "CITS"]
  end

  def ranks_full #Pakāpju pilnie nosaukumi
    ["Mazskauti/Guntiņas", "Skauti/Gaidas", "Dižskauti/Dižgaidas", "Roveri/Lielgaidas"]
  end

  def agent_mobile? #Vai lietotājs lieto mobīlo pārlūku
    request.user_agent =~ /Mobile|webOS/
  end
end
