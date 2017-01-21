import {fromJS} from "immutable"

// decorator for redux-storage to rehydrate using immutablejs
export default (engine) => ({
    ...engine,

    load() {
        return engine.load().then((result) => {
            console.log("load method received", result)
            const immutableResult = fromJS(result)
            return immutableResult
        })
    },
})
