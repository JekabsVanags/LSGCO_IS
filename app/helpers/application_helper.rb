module ApplicationHelper
  def ranks_short
    ["MZSK/GNT", "SK/G", "DZSK/DZG", "ROV/LG", "VAD", "VIEDSK/VIEDG", "CITS"]
  end

  def ranks_full
    ["Mazskauti/Guntiņas", "Skauti/Gaidas", "Dižskauti/Dižgaidas", "Roveri/Lielgaidas"]
  end

  def agent_mobile?
    request.user_agent =~ /Mobile|webOS/
  end
end
