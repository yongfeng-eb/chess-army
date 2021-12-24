import Rails from "@rails/ujs";

const room_id = document.getElementById('room_id').value
const player_detail = document.getElementById('player_detail').value
const user_id = document.getElementById('user_id').value
setInterval(() => {
    window.location.href = '/real_time_info?room_id=' + room_id + '&player_detail=' + player_detail + '&user_id=' + user_id
}, 3000)
