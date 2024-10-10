1	Mô tả chức năng
6.1	Chức năng thông báo
-	Chức năng thông báo trong ứng dụng Mạng Xã Hội là một phần quan trọng giúp người dùng duyệt và tương tác với các hoạt động mới và sự kiện trong cộng đồng của họ. 
-	Hiển thị thông báo về các bài viết của bạn bè khi người dùng nhấn vào biểu tượng thông báo trên màn hình:
+ Khi người dùng nhấn vào biểu tượng thông báo hệ thống sẽ gọi api với id của người dùng đó.
+ Phía api sẽ gửi về một danh sách thông báo về các bài viết của bạn bè người dùng.
+ Tiến hành hiển thị lên màn hình.
-	Cho phép người dùng load lại trang thông báo để hiển thị thông báo mới.
 ![image](https://github.com/user-attachments/assets/26550af7-9c60-4b39-aa6f-81ecab800bf6)

6.2	Chức năng chat riêng
6.2.1	Chức năng hiển thị danh sách bạn bè
-	Chức năng này để hiển thị danh sách bạn bè, cho phép người dùng nhấn vào để điều hướng đến trang chat riêng của từng bạn bè.
-	Cho phép người dùng load lại danh sách bạn bè để hiển thị bạn bè mới nhất.
-	Khi người dùng nhấn vào biểu tượng chat và chọn tab Messages:
+ Hệ thống gọi api với id của người dùng.
+ Phía api sẽ gửi về danh sách bạn bè với các thông tin (username, avatar, id, tin nhắn mới nhất).
+ Tiến hành hiển thị lên màn hình.
-	Cho phép điều hướng đến từng trang chat riêng của từng bạn bè khi nhấn vào.
 
6.2.2	Chức năng gửi tin nhắn chữ
-	Khi được điều hướng đến trang chat riêng hệ thống sẽ tự động load danh sách tin nhắn đã nhắn ra màn hình.
-	Hệ thống sẽ hiển thị avatar bạn bè, tên bạn bè trong header chat.
-	Chức năng này cho phép người dùng gửi tin nhắn chữ realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Nhập tin nhắn vào ô nhập liệu và nhấn biểu tượng gửi.
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.
 
6.2.3	Chức năng gửi tin nhắn ảnh
-	Chức năng này cho phép người dùng gửi tin nhắn ảnh realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Chọn  vào biểu tượng upload, hệ thống sẽ hiển thị một Dialog, tiếp tục nhấn vào button select image.
+ Chọn ảnh và nhấn Send (người dùng có thể nhấn Exit để hủy).
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.
   
6.3	Chức năng chat nhóm
6.3.1	Chức năng hiển thị danh sách nhóm
-	Chức năng này để hiển thị danh sách nhóm, cho phép người dùng nhấn vào để điều hướng đến trang chat riêng của từng nhóm
-	Cho phép người dùng load lại danh sách nhóm để hiển thị nhóm mới nhất.
-	Khi người dùng nhấn vào biểu tượng chat và chọn tab Groups:
+ Hệ thống gọi api với id của người dùng.
+ Phía api sẽ gửi về danh sách nhóm với các thông tin (Tên group, avatar, id, tin nhắn mới nhất).
+ Tiến hành hiển thị lên màn hình.
-	Cho phép điều hướng đến từng trang chat riêng của từng nhóm khi nhấn vào.
 
6.3.2	Chức năng tạo nhóm chat
-	Chức năng này cho phép người dùng tạo nhóm chat để chat với bạn bè với số lượng không chỉ 2 người với nhau như chat riêng.
-	Nhấn vào biểu tượng “+” trong màn hình hệ thống sẽ điều hướng đến trang tạo nhóm:
+ Người dùng tiến hành nhập tên nhóm, mô tả nhóm và chọn hình ảnh đại diện của nhóm.
+ Sau đó tiến hành tạo nhóm hệ thống sẽ gọi api và gửi các thông tin trên cùng với id người dùng.
+ Trong api sẽ lưu vào database với người tạo nhóm sẽ có quyền admin (thực hiện các quyền xóa thêm thành viên, xóa nhóm, cập nhật ảnh đại diện).
+ Hệ thống sẽ hiển thị danh sách nhóm với nhóm mới vừa được tạo.
   

6.3.3	Chức năng xóa nhóm chat
-	Chức năng này cho phép người dùng xóa nhóm chat chỉ áp dụng cho admin (người tạo nhóm).
-	Người dùng sau khi nhấn vào nhóm chat, tiếp tục chọn biểu tượng thông tin nhóm, tiếp tục nhấn vào biểu tượng 3 chấm, chọn xóa nhóm:
+ Hệ thống sẽ hiển Dialog xác nhận cho người dùng, người dùng nhấn OK để xác nhận xóa hoặc chọn Exit để hủy.
+ Sau khi chọn OK hệ thống sẽ gọi api cùng với id group.
+ Api sẽ xóa group trong database.
 
6.3.4	Chức năng hiển thị danh sách thành viên nhóm
-	Chức năng này để hiển thị danh sách thành viên nhóm
-	Cho phép người dùng load lại danh sách nhóm để hiển thị thành viên mới nhất.
-	Khi người dùng nhấn thanh members trong trang thông tin nhóm và chọn vào biểu tượng chat và chọn tab Friends:
+ Hệ thống gọi api với id của người dùng và id group.
+ Phía api sẽ gửi về danh sách bạn bè chưa trong nhóm với các thông tin (Tên bạn bè, avatar, id).
+ Tiến hành hiển thị lên màn hình.
-	Khi người dùng nhấn thanh members trong trang thông tin nhóm và chọn vào biểu tượng chat và chọn tab Add Members:
+ Hệ thống gọi api với id của người dùng và id group.
+ Phía api sẽ gửi về danh sách bạn bè chưa trong nhóm với các thông tin (Tên thành viên, avatar, id, vai trò(admin/member)).
+ Tiến hành hiển thị lên màn hình.
  
6.3.5	Chức năng thêm thành viên
-	Sau khi truy cập vào danh sách thành viên nhóm và chọn tab Add Members:
+ Tiến hành nhấn vào bạn bè.
+ Hệ thống sẽ hiển thị Dialog thông báo xác nhận thêm thành viên.
+ Có thể chọn thêm hoặc hủy.
+ Khi chọn thêm hệ thống sẽ gọi Api với id người dùng và id group để thêm thành viên vào nhóm.
+ Hệ thống sẽ tự động hiển thị lại danh sách.
   
6.3.6	Chức năng xóa thành viên
-	Sau khi truy cập vào danh sách thành viên nhóm và chọn tab Members:
+ Tiến hành nhấn vào thành viên.
+ Hệ thống sẽ hiển thị Dialog thông báo xác nhận thêm thành viên.
+ Có thể chọn xóa hoặc hủy.
+ Khi chọn thêm hệ thống sẽ gọi Api với id người dùng và id group để xóa thành viên vào nhóm.
+ Hệ thống sẽ tự động hiển thị lại danh sách.
   
6.3.7	Chức năng rời nhóm
-	Chức năng này cho phép người dùng rời nhóm chat.
-	Người dùng sau khi nhấn vào nhóm chat, tiếp tục chọn biểu tượng thông tin nhóm, tiếp tục nhấn vào biểu tượng 3 chấm, chọn rời khỏi nhóm:
+ Hệ thống sẽ hiển Dialog xác nhận cho người dùng, người dùng nhấn OK để xác nhận xóa hoặc chọn Exit để hủy.
+ Sau khi chọn OK hệ thống sẽ gọi api cùng với id group, id người dùng.
+ Api sẽ xóa người dùng khỏi group trong database.
 
6.3.8	Chức năng cập nhật ảnh đại diện nhóm
-	Chức năng này cho phép người dùng cập nhật lại ảnh đại diện của nhóm khi nhấn vào cập nhật ảnh nhóm:
+ Hệ thống hiển thị Dialog cập nhật ảnh, sau đó chọn Select Image để chọn ảnh và nhấn update để cập nhật hoặc close để hủy.
+ Khi nhấn vào Update hệ thống sẽ gọi api nhận vào id group để cập nhật lại ảnh mới trong database.
+ Hệ thống tự động hiển thị lại ảnh sau khi đã hoàn tất các bước trên.
 
6.3.9	Chức năng gửi tin nhắn chữ
-	Khi được điều hướng đến trang chat nhóm hệ thống sẽ tự động load danh sách tin nhắn đã nhắn ra màn hình (hiển thị tin nhắn của từng người với avatar của người dùng đó để biết ai là người gửi tin nhắn).
-	Hệ thống sẽ hiển thị avatar nhóm, tên nhóm trong header chat.
-	Chức năng này cho phép người dùng gửi tin nhắn chữ realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Nhập tin nhắn vào ô nhập liệu và nhấn biểu tượng gửi.
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.
 
6.3.10	Chức năng gửi tin nhắn ảnh
-	Chức năng này cho phép người dùng gửi tin nhắn ảnh realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Chọn  vào biểu tượng upload, hệ thống sẽ hiển thị một Dialog, tiếp tục nhấn vào button select image.
+ Chọn ảnh và nhấn Send (người dùng có thể nhấn Exit để hủy).
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.


   


6.4	Bài viết
6.4.1	Đăng bài viết
Người dùng nhập đầy đủ nội dung và có thể chọn ảnh trong điện thoại để đăng bài viết
 
6.4.2	Hiển thị bài viết
HIển thị các bài viết của bản thân đã đăng hoặc của bạn bè đã kết bạn hoặc đã gửi lời mời kết bạn hoặc đã có lời mời kết bạn đang chờ xác nhận. Và sắp xếp thứ tự bài viết theo thời gian đăng bài viết
Khi trượt lên hết cỡ thì sẽ load lại thông tin mới nhất bằng cách gọi lại các api

 
6.4.3	Bình luận
Người dùng nhập nội dung bình luận và có thể chọn ảnh từ điện thoại để gửi bình luận cho 1 bài viết
 

6.5	Bạn bè
HIển thị các danh sách bạn bè của tôi, đề xuất, lời mời đã gửi, lời mời chờ xác nhận
Bấm vào các biểu tượng chat sẽ chuyển qua màn hình chat riêng ở trong tab My Friends
Bấm vào các biểu tượng kết bạn sẽ gửi lời mời kết bạn ở tab Suggest
Bấm vào các biểu tượng đồng ý hoặc hủy bỏ sẽ chấp nhận lời mời hoặc từ chối lời mời ở tab Incoming
Bấm vào các biểu tượng hủy bỏ sẽ hủy lời mời kết bạn đã gửi ở tab OutComing
Khi vào trang cá nhân bạn bè cũng sẽ có các chức năng tương tự
Khi trượt lên hết cỡ thì sẽ load lại thông tin mới nhất bằng cách gọi lại các api
      
6.6	Thống kê
Admin có thể chọn màu app tùy ý muốn và xem các thống kê.
  
6.7	Thông tin tài khoản cá nhân
Người dùng có thể thấy thông tin cá nhân ở các màn hình Profile, Edit Persional Information, My Profile
Có thể cập nhật các thông tin hoặc hình ảnh đại diện của tài khoản cá nhân ở trang Edit Persional Information
Xem các thông tin khác như số bạn bè, số lượt theo dõi và các bài viết đã đăng ở trang My Profile
   
6.8	Tài khoản
Nhập đúng email và mật khẩu đã đăng ký để sử dụng app ở màn hình Login
Nhập tên, email, mật khẩu, nhập lại mật khẩu và chọn giới tính để đăng ký ở màn hình Register
Nhập mật khẩu cũ, mật khẩu mới và nhập lại mật khẩu mới để đổi mật khẩu ở màn hình Change Password
      
6.9	Khôi phục tài khoản
Để khôi phục tài khoản khi quên mật khẩu, nhập đúng email đã đăng ký ở màn hình Forgot Password để gửi mã xác minh có 6 số về email
Sau khi nhận mã xác minh thì hãy hập mã xác minh đã gửi về email để xác thực ở màn hình Reset Password Verification
Sau khi xác mình, nhập mật khẩu mới và nhập lại mật khẩu mới ở màn hình Change Password để đổi lại mật khẩu mới
     

