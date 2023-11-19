module ApplicationHelper
  def ranks_short
    ["MZSK/GNT", "SK/G", "DZSK/DZG", "ROV/LG", "VAD", "VIEDSK/VIEDG", "CITS"]
  end

  def ranks_full
    ["Mazskauti/Guntiņas", "Skauti/Gaidas", "Dižskauti/Dižgaidas", "Roveri/Lielgaidas"]
  end

  def registration_positions(event_id)
    positions = []
    event = Event.find(event_id)
    if Invite.where(rank: current_user.rank, unit: current_user.unit, event: event).present?
      positions.push("Dalībnieks")
    end
    if current_user.unit == event.unit
      positions.push("Organizētājs")
    end
    if current_user.volunteer
      positions.push("Brīvprātīgais")
    end

    return positions
  end

  def current_user_registered_for(event_id)
    event = Event.find(event_id)
    registration = EventRegistration.where(user: current_user, event:).first
  end
end
