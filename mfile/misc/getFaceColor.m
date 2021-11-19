function face_color = getFaceColor(stimulus_type)
    stimulus_type = string(stimulus_type);
    if stimulus_type == "neutral"
        face_color = 'green';
    elseif stimulus_type == "standard" 
        face_color = 'yellow';
    elseif stimulus_type == "personal"
        face_color = 'red';
    elseif stimulus_type == "fixation"
        face_color = [0.5 0.5 0.5];
    end

end
