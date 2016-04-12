json.array!(@participants) do |participant|
  json.extract! participant, :id, :event_id, :name, :title, :division, :biography
  json.url participant_url(participant, format: :json)
end
