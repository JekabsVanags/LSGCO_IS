module RegistrationHelpers
  def registration_positions(event_id) #Lietotāja iespējamās pozīcijas kurās reģistrēties
    positions = []
    event = Event.find(event_id)
    if Invite.where(rank: current_user.rank, unit: current_user.unit, event: event).present? #Ja lietotāja pakāpe un vienība ielūgta, var kā dalībnieks.
      positions.push("Dalībnieks")
    end
    if current_user.unit == event.unit && current_user.rank > 0 #Ja lietotāja vienība organizē un nav mazskauts, var kā organizētājs.
      positions.push("Organizētājs")
    end
    if current_user.volunteer #Ja lietotājs ir brīvprātīgais, var kā brīvprātīgais
      positions.push("Brīvprātīgais")
    end

    return positions
  end

  def current_user_registered_for(event_id) #Vai lietotājs ir reģistrējies pasākumam
    event = Event.find(event_id)
    EventRegistration.where(user: current_user, event: event).first #Atgriežam reģistrāciju
  end
end
