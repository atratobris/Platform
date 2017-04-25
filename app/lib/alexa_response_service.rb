class AlexaResponseService
  def initialize params, board
    @params = params
    @board = board
    @sketch = Sketch
      .where("boards @> '[{\"mac\":\"#{board.mac}\"}]'")
      .where(status: :active)
      .first
  end

  # Construct response returned to Skill Interface
  def construct_response(text, reprompt_text="", session_attributes=nil, session_end=false)
    if text.present?
      {"response": {
          "outputSpeech": {
            "type": "PlainText",
            "text": text
          },
          'card': {
            "type": 'Standard',
            "title": 'My Sketches',
            "text": text
          },
          "reprompt": {
            "outputSpeech": {
              "type": "PlainText",
              "text": reprompt_text
            }
          },
          "shouldEndSession": false
        },
        "sessionAttributes": {}
      }
    else
      {"response": {
          "outputSpeech": {
            "type": "PlainText",
            "text": ""
          },
          "shouldEndSession": false
        }
      }
    end
  end

  def intent_status_response
    if @sketch.nil?
      self.construct_response "Not part of any running sketch"
    else
      self.construct_response "I am part of a running sketch"
    end
  end

  def intent_activate_response
    if @sketch.nil?
      self.construct_response "Sorry, but I am not part of any running sketch"
    else
      InputBroadcastJob.perform_now @board
      self.construct_response ""
    end
  end


end