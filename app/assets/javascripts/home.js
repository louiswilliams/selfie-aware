function process_images(user_id, callback) {
    $.post("/ajax/process_images", {"user_id" : user_id}).done(function(data) {
        callback(data);
    });
}
function get_images(user_id, callback) {
    $.post("/ajax/get_images", {"user_id" : user_id}).done(function(data) {
        callback(data);
    });
}
function get_search_results(query, callback) {
    $.post("/ajax/search", {"query": query}).done(function(data) {
        callback(data);
    });
}
function get_follows(user_id, callback) {
    $.post("/ajax/get_follows", {"user_id": user_id}).done(function(data) {
        callback(data);
    })
}