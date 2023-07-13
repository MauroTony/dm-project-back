from libs.api.api_handler import APIHandler


manager = APIHandler()
database = manager.mongo.db
if __name__ == '__main__':
    from modules.users.controller import UserResource
    from modules.auth.controller import LoginResource, LogoutResource
    from modules.credit_card.controller import CardResource, AnaliseResource, AnaliseListResource
    manager.inject_router(UserResource, '/user')
    manager.inject_router(LoginResource, '/login')
    manager.inject_router(LogoutResource, '/logout')
    manager.inject_router(CardResource, '/credit-card')
    manager.inject_router(AnaliseResource, '/analise')
    manager.inject_router(AnaliseListResource, '/analise-list')
    manager.start()