propsClass = {}

function propsClass:RequestModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end