Board.create! mac: "1234"
Board.create! mac: "5678"

boards = ["{\"id\":1,\"mac\":\"B4:21:8A:F5:0A:BA\",\"button\":false,\"created_at\":\"2017-02-27T19:15:51.055Z\",\"updated_at\":\"2017-02-27T22:42:40.353Z\",\"status\":\"online\",\"metadata\":{\"13\":0,\"type\":\"Led\"},\"name\":\"LED\",\"last_active\":\"2017-02-27T22:42:40.352Z\",\"maintype\":\"output\",\"type\":\"Led\"}",
  "{\"id\":4,\"mac\":\"B4:21:8A:F5:0E:A4\",\"button\":false,\"created_at\":\"2017-02-27T19:17:33.776Z\",\"updated_at\":\"2017-02-27T22:42:40.383Z\",\"status\":\"online\",\"metadata\":{\"id\":1,\"href\":\"http://cnn.it/go2\",\"type\":\"Lcd\",\"value\":\"CNNgo - CNN.com\"},\"name\":\"LCD\",\"last_active\":\"2017-02-27T22:42:40.382Z\",\"maintype\":\"output\",\"type\":\"Lcd\"}",
  "{\"id\":2,\"mac\":\"B4:21:8A:F5:0B:17\",\"button\":false,\"created_at\":\"2017-02-27T19:16:10.537Z\",\"updated_at\":\"2017-02-27T22:30:56.829Z\",\"status\":\"online\",\"metadata\":{\"id\":2,\"href\":\"http://us.cnn.com/2017/02/27/politics/paul-ryan-mike-pence-congressional-meetings/index.html\",\"type\":\"lcd_display\",\"value\":\"How Paul Ryan is getting Trump's team ready for battles in Congress\"},\"name\":\"Motion Sensor\",\"last_active\":\"2017-02-27T22:30:56.827Z\",\"maintype\":\"input\",\"type\":\"Input\"}",
  "{\"id\":5,\"mac\":\"UNIX|Chrome|56:0:2924:87\",\"button\":false,\"created_at\":\"2017-02-27T19:23:39.728Z\",\"updated_at\":\"2017-02-28T16:03:09.052Z\",\"status\":\"offline\",\"metadata\":{\"url\":\"www.google.com\",\"type\":\"link_opener\"},\"name\":\"Laptop Somi\",\"last_active\":\"2017-02-28T01:13:40.804Z\",\"maintype\":\"output\",\"type\":\"Screen\"}",
  "{\"id\":3,\"mac\":\"B4:21:8A:F0:2E:23\",\"button\":false,\"created_at\":\"2017-02-27T19:16:24.447Z\",\"updated_at\":\"2017-02-27T22:31:32.102Z\",\"status\":\"online\",\"metadata\":{\"id\":10,\"href\":\"http://www.pornhub.com/view_video.php?viewkey=ph5895c08194d4b\",\"type\":\"lcd_display\",\"value\":\"Mama lui Paul live\"},\"name\":\"Button\",\"last_active\":\"2017-02-27T22:31:32.101Z\",\"maintype\":\"input\",\"type\":\"Input\"}"]

boards.each{ |board| Board.create(JSON.parse(board).delete_if{ |k, _| ["id", "button"].include?(k) }) }

ExternalDatum.create! source_type: 0, name: 'NY Times', url: '', data: [{href: '', title: 'First headline'}]

Sketch.create! links: [{from: '1234', to: '5678', logic: 'toggle'}],
  boards: [{mac: '1234', centre: {x: 120, y: 120}, width: 40, height: 40},
    {mac: '5678', centre: {x: 240, y: 120}, width: 40, height: 40}]
