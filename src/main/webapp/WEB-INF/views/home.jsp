<html>
    <head>
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.4/sockjs.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    </head>
    <body>
    
        <script>
            function onConnected() {
                stompClient.subscribe('/topic/messages', onMessageReceived);
                stompClient.subscribe('/user/queue/events', onEventReceived);
            }

            function onError(error) {
                console.log('Could not connect to WebSocket server. Please refresh this page to try again! ' + error);
            }

            function onMessageReceived(payload) {
                var msg = JSON.parse(payload.body);
                $('#chat').append('[' + msg.from + '] ' + msg.content + "\n");
            }

            function onEventReceived(payload) {
                var msg = JSON.parse(payload.body);
                $('#notificationsArea').append(msg.content + "\n");
            }
            
            function sendMessage() {
                var content = $('#newMsgInput').val();
                if (!content) {
                    return;
                }
                var msg = {
                    from: '${user.name}',
                    content: $('#newMsgInput').val()
                };
                
                stompClient.send("/topic/messages", {}, JSON.stringify(msg));
                $('#newMsgInput').val(null);
            }
            
            var socket = new SockJS('/ws');
            var stompClient = Stomp.over(socket);
            stompClient.connect({}, onConnected, onError);
            
            console.log('connected to WS');
        </script>
    
        <div style="display: flex;">
         
            <div style="display: flex; flex-direction: column; width: 30%;">
                <h3 style="text-align: center;">Chat</h3>
                
                <textarea id="chat" style="text-align:left; height:250px; margin: 1rem;"></textarea>
                
                <input id="newMsgInput" style="height:50px; margin: 1rem;" />
                
                <button style="width: 100px; margin: 1rem;" onclick="sendMessage();">Send</button>
            </div>
            
            <div>
                <h3 style="text-align: center;">Server Notifications</h3>
                
                <div>
                    <textarea id="notificationsArea" style="text-align:left; width: 300px; height:250px; margin: 1rem;"></textarea>
                </div>
            </div>
            

        </div>
        
        <form id="logoutForm" method="POST" action="/logout">
            <button type="submit" style="margin-top: 2rem;">Log Out</button>
        </form>
    </body>
</html>