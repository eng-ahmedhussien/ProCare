// MARK: - View State
enum LoadingState {
    case idle
    case loading
    case loaded
    case failed(String)
}