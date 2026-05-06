const express = require('express')
const cors = require('cors')
const app = express()
const port = 3000

app.use(cors())

const products = [
	{id: 1, name: 'foo', price: 99},
	{id: 2, name: 'bar', price: 10}
]

app.get('/products', (req, res) => {
	res.json(products)
})

app.post('/payments', (req, res) => {
	res.sendStatus(201)
})

app.listen(port, () => {
	console.log(`app listening on port ${port}`)
})