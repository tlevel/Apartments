(function(){
window.JST = window.JST || {};

window.JST['apartments/create_thumb'] = _.template('<li class="span3" >\n  <div class="thumbnail">\n      <img src="<%= url + item.data %>" alt="ALT NAME" style="height: 150px ">\n      <input type="hidden" name="images[]" value="<%= item.data %>" />\n    <div class="caption">\n      <p align="center"><a onclick="javascript: create.remove_click(this)" class="btn btn-primary btn-block remove-th">Remove</a></p>\n    </div>\n  </div>\n</li>');
window.JST['search/apartment'] = _.template('<div class="apblock" >\n    <h4><%= item.ap.title %></h4>\n    <div class="tabbable tabs-below">\n        <% var rand = Math.floor(Math.random()*100000) %>\n        <div class="tab-content">\n            <div class="tab-pane ap-block center" id="lA<%=rand %>">\n                <ul id="gallery">\n                    <% _.each(item.images, function(image, index) { %>\n                        <% if (image.id == 0) { %>\n                            <li><img src="<%= image.name %>" alt="">\n                        <% } else { %>\n                            <li><img src="<%= url + \'files/apartments/\'+ item.ap.id + \'/photos/\' + image.name %>" alt="">\n                        <% } %>\n                    <% }) %>\n                </ul>\n            </div>\n            <div class="tab-pane active ap-block" id="lB<%=rand %>">\n                <div class="justified" style="margin-left: 0px" >\n                    <div>\n                        <strong>Description:</strong>\n                        <%= item.ap.descr %>\n                    </div>\n                    <div>\n                        <strong>Address:</strong>\n                        <%= item.ap.address %>\n                    </div>\n                    <div>\n                        <strong>Rooms:</strong>\n                        <%= item.ap.type_id %>\n                    </div>\n                    <div>\n                        <strong>Smoking:</strong>\n                        <% if (item.ap.smoking == 0){ %>\n                            No\n                        <% } else { %>\n                            Yes\n                        <% } %>\n                    </div>\n                    <div>\n                        <strong>Pets:</strong>\n                        <% if (item.ap.pets == 0){ %>\n                            No\n                        <% } else if (item.ap.pets == 1) { %>\n                            Yes\n                        <% } else { %>\n                            Some considered\n                        <% } %>\n                    </div>\n                    <div>\n                        <strong>Cost:</strong>\n                        <span class="label label-success">$<%= item.ap.cost %></span>\n                    </div>\n                </div>\n            </div>\n            <div class="tab-pane ap-block center" id="lC<%=rand %>">\n                <% if (item.application_id == 0) { %>\n                    <button class="btn btn-danger" disabled >You should log in or fill the application form in user profile</button>\n                <% } else { %>\n                    <p><a href="<%= SYS.baseUrl + \'user/application\' %>">Please follow the link and fill the form as much as you can</a><p>\n                    <button class="btn btn-primary" id="application" onclick="javascript: map.add_to_sends(<%= item.application_id %> , this, \'<%= item.email %>\' )" >Send Application</button>\n                <% } %>\n            </div>\n            <div class="tab-pane ap-block" id="lD<%=rand %>">\n                <div class="center">\n                    <% if (item.fav.user_id != 0) { %>\n                    <button class="btn btn-primary <%= item.fav.status ? \'disabled\' : \'\' %>" id="favorite" onclick="javascript: map.add_to_favorite(<%= item.ap.id %> , this, <%= item.fav.user_id %> )" ><%= item.fav.status ? \'In Favorites\' : \'Add to Favorites\'%></button>\n                    <% } else { %>\n                    <button class="btn btn-danger disabled" id="favorite" >You should sign in to use favorites feature</button>\n                    <% } %>\n                </div>\n            </div>\n        </div>\n        <ul class="nav nav-tabs" style="width: 360px">\n            <li><a href="#lA<%=rand %>" data-toggle="tab">Photos</a></li>\n            <li class="active"><a href="#lB<%=rand %>" data-toggle="tab">Details</a></li>\n            <li><a href="#lC<%=rand %>" data-toggle="tab">Apply</a></li>\n            <li><a href="#lD<%=rand %>" data-toggle="tab">Add to Favorites</a></li>\n        </ul>\n    </div>\n\n</div>');
})();