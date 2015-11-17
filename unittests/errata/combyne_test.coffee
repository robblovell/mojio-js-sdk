describe 'Test Combyne Inversion.', ->
    it 'return field changes', ->

        test = (r) ->
            r.a = 1
            return r
        x = { a: 2 }
        console.log(JSON.stringify(x))

        y = test(x)
        console.log(JSON.stringify(x))
        console.log(JSON.stringify(y))
