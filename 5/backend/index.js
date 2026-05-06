
const express = require('express')
const app = express()
const port = 3000

const products = [
	{name: 'foo', price: 99},
	{name: 'bar', price: 10}
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