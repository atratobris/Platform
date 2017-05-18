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
          "shouldEndSession": true
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
      Log.received "Received input from Alexa device"
      InputBroadcastJob.perform_now @board
      self.construct_response "Ok"
    end
  end

  def intent_story_response
    story_text = "Hello all. I am going to tell you the story of Paul who has just managed to automate his home using some I o T devices.  
Paul has arrived home from work and wants to get up to date with the recent news articles using the devices he has set up. He sits down 
at his table and has a look at the mini LCD screen. He starts swiping in front of the motion sensor in order to go through some articles. As he 
finds an interesting article, he pushes the button next to him in order to open that article on his laptop screen. 
While the article is being opened on his laptop, the light also comes on to help Paul feel more comfortable reading the latest news."
    self.construct_response story_text
  end


end