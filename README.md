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

 ![image](https://github.com/user-attachments/assets/fc2e7845-0da6-49ed-9946-a2c72ccb8971)

6.2.2	Chức năng gửi tin nhắn chữ
-	Khi được điều hướng đến trang chat riêng hệ thống sẽ tự động load danh sách tin nhắn đã nhắn ra màn hình.
-	Hệ thống sẽ hiển thị avatar bạn bè, tên bạn bè trong header chat.
-	Chức năng này cho phép người dùng gửi tin nhắn chữ realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Nhập tin nhắn vào ô nhập liệu và nhấn biểu tượng gửi.
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.

![image](https://github.com/user-attachments/assets/a072d423-c835-42ef-8626-82296a350a2d)

 
6.2.3	Chức năng gửi tin nhắn ảnh
-	Chức năng này cho phép người dùng gửi tin nhắn ảnh realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Chọn  vào biểu tượng upload, hệ thống sẽ hiển thị một Dialog, tiếp tục nhấn vào button select image.
+ Chọn ảnh và nhấn Send (người dùng có thể nhấn Exit để hủy).
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.
   ![image](https://github.com/user-attachments/assets/ce6739e8-9a14-474d-b56b-dff3cd86cbdb)
![image](https://github.com/user-attachments/assets/84cc134a-eb76-4984-98c8-5a8f690a7810)
![image](https://github.com/user-attachments/assets/eaae1f25-8837-4086-bd77-27bddf20569a)

6.3	Chức năng chat nhóm
6.3.1	Chức năng hiển thị danh sách nhóm
-	Chức năng này để hiển thị danh sách nhóm, cho phép người dùng nhấn vào để điều hướng đến trang chat riêng của từng nhóm
-	Cho phép người dùng load lại danh sách nhóm để hiển thị nhóm mới nhất.
-	Khi người dùng nhấn vào biểu tượng chat và chọn tab Groups:
+ Hệ thống gọi api với id của người dùng.
+ Phía api sẽ gửi về danh sách nhóm với các thông tin (Tên group, avatar, id, tin nhắn mới nhất).
+ Tiến hành hiển thị lên màn hình.
-	Cho phép điều hướng đến từng trang chat riêng của từng nhóm khi nhấn vào.

![image](https://github.com/user-attachments/assets/34c534c6-7497-4d54-b9a5-c3b09c03354f)

 
6.3.2	Chức năng tạo nhóm chat
-	Chức năng này cho phép người dùng tạo nhóm chat để chat với bạn bè với số lượng không chỉ 2 người với nhau như chat riêng.
-	Nhấn vào biểu tượng “+” trong màn hình hệ thống sẽ điều hướng đến trang tạo nhóm:
+ Người dùng tiến hành nhập tên nhóm, mô tả nhóm và chọn hình ảnh đại diện của nhóm.
+ Sau đó tiến hành tạo nhóm hệ thống sẽ gọi api và gửi các thông tin trên cùng với id người dùng.
+ Trong api sẽ lưu vào database với người tạo nhóm sẽ có quyền admin (thực hiện các quyền xóa thêm thành viên, xóa nhóm, cập nhật ảnh đại diện).
+ Hệ thống sẽ hiển thị danh sách nhóm với nhóm mới vừa được tạo.

![image](https://github.com/user-attachments/assets/bdabcca3-b1bb-4dc4-aa24-b7d9326e519b)


6.3.3	Chức năng xóa nhóm chat
-	Chức năng này cho phép người dùng xóa nhóm chat chỉ áp dụng cho admin (người tạo nhóm).
-	Người dùng sau khi nhấn vào nhóm chat, tiếp tục chọn biểu tượng thông tin nhóm, tiếp tục nhấn vào biểu tượng 3 chấm, chọn xóa nhóm:
+ Hệ thống sẽ hiển Dialog xác nhận cho người dùng, người dùng nhấn OK để xác nhận xóa hoặc chọn Exit để hủy.
+ Sau khi chọn OK hệ thống sẽ gọi api cùng với id group.
+ Api sẽ xóa group trong database.

![image](https://github.com/user-attachments/assets/387ab290-17d1-4f2d-b29d-5ce444aa6789)


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

![image](https://github.com/user-attachments/assets/2423c2f3-846b-4eec-b799-ae1c08965d06)

6.3.5	Chức năng thêm thành viên
-	Sau khi truy cập vào danh sách thành viên nhóm và chọn tab Add Members:
+ Tiến hành nhấn vào bạn bè.
+ Hệ thống sẽ hiển thị Dialog thông báo xác nhận thêm thành viên.
+ Có thể chọn thêm hoặc hủy.
+ Khi chọn thêm hệ thống sẽ gọi Api với id người dùng và id group để thêm thành viên vào nhóm.
+ Hệ thống sẽ tự động hiển thị lại danh sách.

![image](https://github.com/user-attachments/assets/9ac716ba-723a-4c75-a242-18e7acf923a5)

6.3.6	Chức năng xóa thành viên
-	Sau khi truy cập vào danh sách thành viên nhóm và chọn tab Members:
+ Tiến hành nhấn vào thành viên.
+ Hệ thống sẽ hiển thị Dialog thông báo xác nhận thêm thành viên.
+ Có thể chọn xóa hoặc hủy.
+ Khi chọn thêm hệ thống sẽ gọi Api với id người dùng và id group để xóa thành viên vào nhóm.
+ Hệ thống sẽ tự động hiển thị lại danh sách.

![image](https://github.com/user-attachments/assets/a116498f-0062-4daa-8c0f-c738cbf2ce60)


6.3.7	Chức năng rời nhóm
-	Chức năng này cho phép người dùng rời nhóm chat.
-	Người dùng sau khi nhấn vào nhóm chat, tiếp tục chọn biểu tượng thông tin nhóm, tiếp tục nhấn vào biểu tượng 3 chấm, chọn rời khỏi nhóm:
+ Hệ thống sẽ hiển Dialog xác nhận cho người dùng, người dùng nhấn OK để xác nhận xóa hoặc chọn Exit để hủy.
+ Sau khi chọn OK hệ thống sẽ gọi api cùng với id group, id người dùng.
+ Api sẽ xóa người dùng khỏi group trong database.

![image](https://github.com/user-attachments/assets/f8c1e7b0-6517-4bca-9d94-8ae63a51d465)


6.3.8	Chức năng cập nhật ảnh đại diện nhóm
-	Chức năng này cho phép người dùng cập nhật lại ảnh đại diện của nhóm khi nhấn vào cập nhật ảnh nhóm:
+ Hệ thống hiển thị Dialog cập nhật ảnh, sau đó chọn Select Image để chọn ảnh và nhấn update để cập nhật hoặc close để hủy.
+ Khi nhấn vào Update hệ thống sẽ gọi api nhận vào id group để cập nhật lại ảnh mới trong database.
+ Hệ thống tự động hiển thị lại ảnh sau khi đã hoàn tất các bước trên.

![image](https://github.com/user-attachments/assets/aa43e6e5-e69b-48a3-b30d-1c5ddfcfbeb9)


6.3.9	Chức năng gửi tin nhắn chữ
-	Khi được điều hướng đến trang chat nhóm hệ thống sẽ tự động load danh sách tin nhắn đã nhắn ra màn hình (hiển thị tin nhắn của từng người với avatar của người dùng đó để biết ai là người gửi tin nhắn).
-	Hệ thống sẽ hiển thị avatar nhóm, tên nhóm trong header chat.
-	Chức năng này cho phép người dùng gửi tin nhắn chữ realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Nhập tin nhắn vào ô nhập liệu và nhấn biểu tượng gửi.
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.

![image](https://github.com/user-attachments/assets/8169bad5-65a3-41b4-9ef2-f651e8b85ff6)

 
6.3.10	Chức năng gửi tin nhắn ảnh
-	Chức năng này cho phép người dùng gửi tin nhắn ảnh realtime bằng Websocket để người dùng có thể nhận tin nhắn ngay khi gửi:
+ Chọn  vào biểu tượng upload, hệ thống sẽ hiển thị một Dialog, tiếp tục nhấn vào button select image.
+ Chọn ảnh và nhấn Send (người dùng có thể nhấn Exit để hủy).
+ Hệ thống sẽ gọi websocket và đồng thời gọi api lưu vào database, cũng hiển thị tin nhắn ra màn hình.
+ Phía bên người nhận sẽ nhận được thông báo từ websocket và load tin nhắn mới nhất qua api và hiển thị lên màn hình.

![image](https://github.com/user-attachments/assets/978aa822-f5e2-418b-9d9a-89214516dfeb)
![image](https://github.com/user-attachments/assets/431d83a8-8904-4933-bfb8-c0fb0305dae4)




6.4	Bài viết
6.4.1	Đăng bài viết
Người dùng nhập đầy đủ nội dung và có thể chọn ảnh trong điện thoại để đăng bài viết

![image](https://github.com/user-attachments/assets/b6481ec7-e8a6-4e88-a81f-989c49174ea1)

 
6.4.2	Hiển thị bài viết
HIển thị các bài viết của bản thân đã đăng hoặc của bạn bè đã kết bạn hoặc đã gửi lời mời kết bạn hoặc đã có lời mời kết bạn đang chờ xác nhận. Và sắp xếp thứ tự bài viết theo thời gian đăng bài viết
Khi trượt lên hết cỡ thì sẽ load lại thông tin mới nhất bằng cách gọi lại các api

![image](https://github.com/user-attachments/assets/d3506647-184e-4eef-89ec-753c525ec348)

 
6.4.3	Bình luận
Người dùng nhập nội dung bình luận và có thể chọn ảnh từ điện thoại để gửi bình luận cho 1 bài viết
 
![image](https://github.com/user-attachments/assets/c599e111-3700-46db-b7ff-a62157dadb31)


6.5	Bạn bè
HIển thị các danh sách bạn bè của tôi, đề xuất, lời mời đã gửi, lời mời chờ xác nhận
Bấm vào các biểu tượng chat sẽ chuyển qua màn hình chat riêng ở trong tab My Friends
Bấm vào các biểu tượng kết bạn sẽ gửi lời mời kết bạn ở tab Suggest
Bấm vào các biểu tượng đồng ý hoặc hủy bỏ sẽ chấp nhận lời mời hoặc từ chối lời mời ở tab Incoming
Bấm vào các biểu tượng hủy bỏ sẽ hủy lời mời kết bạn đã gửi ở tab OutComing
Khi vào trang cá nhân bạn bè cũng sẽ có các chức năng tương tự
Khi trượt lên hết cỡ thì sẽ load lại thông tin mới nhất bằng cách gọi lại các api

![image](https://github.com/user-attachments/assets/d0fe80a5-1b74-4e30-aa30-173b93b621ff)
![image](https://github.com/user-attachments/assets/9cc6923c-13b7-4cdc-94c5-8ce54d4fe2a2)
![image](https://github.com/user-attachments/assets/c33341ba-81a3-4160-a503-c9ffa54f192c)
![image](https://github.com/user-attachments/assets/ac8b42da-efc6-4acb-b9d9-71c90d392830)
![image](https://github.com/user-attachments/assets/af298913-92e8-4291-be5f-e8e21eefb11b)
![image](https://github.com/user-attachments/assets/6874eded-b7a0-4cb3-b2fe-ce5d8254f404)


6.6	Thống kê
Admin có thể chọn màu app tùy ý muốn và xem các thống kê.

![image](https://github.com/user-attachments/assets/5d451dea-b556-483e-aefb-5d403827c15d)
![image](https://github.com/user-attachments/assets/3481a7dc-0499-4182-803d-c0c837ce8ec2)

  
6.7	Thông tin tài khoản cá nhân
Người dùng có thể thấy thông tin cá nhân ở các màn hình Profile, Edit Persional Information, My Profile
Có thể cập nhật các thông tin hoặc hình ảnh đại diện của tài khoản cá nhân ở trang Edit Persional Information
Xem các thông tin khác như số bạn bè, số lượt theo dõi và các bài viết đã đăng ở trang My Profile

![image](https://github.com/user-attachments/assets/873a331d-c119-448b-93f4-214130903f13)
![image](https://github.com/user-attachments/assets/e7e42aba-f8a6-4d99-a378-efdba6b34f5e)



6.8	Tài khoản
Nhập đúng email và mật khẩu đã đăng ký để sử dụng app ở màn hình Login
Nhập tên, email, mật khẩu, nhập lại mật khẩu và chọn giới tính để đăng ký ở màn hình Register
Nhập mật khẩu cũ, mật khẩu mới và nhập lại mật khẩu mới để đổi mật khẩu ở màn hình Change Password

![image](https://github.com/user-attachments/assets/8950a820-5d23-4df3-9e4e-69cf143b7276)
![image](https://github.com/user-attachments/assets/5aab12e6-38b1-408b-b8e1-4ccc6c6c540b)
![image](https://github.com/user-attachments/assets/9615feeb-61be-4cf9-9a59-426fda941724)

      
6.9	Khôi phục tài khoản
Để khôi phục tài khoản khi quên mật khẩu, nhập đúng email đã đăng ký ở màn hình Forgot Password để gửi mã xác minh có 6 số về email
Sau khi nhận mã xác minh thì hãy hập mã xác minh đã gửi về email để xác thực ở màn hình Reset Password Verification
Sau khi xác mình, nhập mật khẩu mới và nhập lại mật khẩu mới ở màn hình Change Password để đổi lại mật khẩu mới

![image](https://github.com/user-attachments/assets/05633c5e-051d-4440-8341-42d369f873d2)
![image](https://github.com/user-attachments/assets/30846875-6665-4e53-9b4e-125dc678c9a1)
![image](https://github.com/user-attachments/assets/6248a964-c412-4b5e-9a75-7e5ca347d37e)


