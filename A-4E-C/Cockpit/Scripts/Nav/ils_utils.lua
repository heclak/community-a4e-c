function get_ils_data_in_format()
    filename = get_terrain_related_data("beacons") or get_terrain_related_data("beaconsFile")
    
    ils_data = {}
    marker_data = {}
  
    if filename ~= nil then
      dofile(filename)
  
      for i, v in pairs(beacons) do
  
        if v.type == BEACON_TYPE_ILS_GLIDESLOPE or v.type == BEACON_TYPE_ILS_LOCALIZER then
          if ils_data[v.callsign] == nil then
            ils_data[v.callsign] = {name = v.display_name, callsign = v.callsign}
          end
  
          local direction = v.direction
          if direction < 0 then
            direction = 360 + direction
          end

          ils_data[v.callsign][v.type] = {
            position = {x = v.position[1], y = v.position[2], z = v.position[3]},
            direction = direction,
            frequency = v.frequency,
          }
  
        elseif v.type == BEACON_TYPE_AIRPORT_HOMER_WITH_MARKER or v.type == BEACON_TYPE_ILS_FAR_HOMER or v.type == BEACON_TYPE_ILS_NEAR_HOMER then
            local far = false
            if v.type == BEACON_TYPE_ILS_FAR_HOMER then
                far = true
            end

            marker_data[#marker_data + 1] = {
                position = {x = v.position[1], y = v.position[2], z = v.position[3]},
                far = far,
            }
        else
          --print_message_to_user("BEACON: "..tostring(getTACANFrequency(31, 'X')*1e-6).." TYPE: "..tostring(v.type))

        end
  
      end
    end
  
    ils_data_ordered = {}
  
    for i, v in pairs(ils_data) do
      ils_data_ordered[#ils_data_ordered + 1] = v
    end
  
    return ils_data_ordered, marker_data
  end