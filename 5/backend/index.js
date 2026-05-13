const express = require('express')
const cors = require('cors')
const app = express()
const port = 3000

app.use(cors())
app.use(express.json())

const products = {
	1: {name: 'foo', price: 99},
	2: {name: 'bar', price: 10}
}

app.get('/products', (req, res) => {
	res.json(products)
})

app.post('/payment', (req, res) => {
	paid = 0
	for (k in req.body) {
		if (k in products) {
			paid += req.body[k] * products[k].price
		}
	}

	res.json({paid})
})

app.listen(port, () => {
	console.log(`app listening on port ${port}`)
})
