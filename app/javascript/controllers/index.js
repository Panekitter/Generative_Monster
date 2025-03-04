import { application } from "./application"
import { registerControllers } from "./register_controllers"

// 必要に応じて各コントローラーを個別にインポート
import DeleteCharacterController from "./delete_character_controller"

// コントローラーを手動で登録
application.register("delete-character", DeleteCharacterController)

// 他のコントローラーも必要に応じて登録
// application.register("other-controller", OtherController)