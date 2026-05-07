import './App.css'
import { Products } from './Products'
import { Cart } from './Cart'
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { useReducer } from 'react';

function Home() {
	return <h1>Home Page</h1>;
}

function Payments() {
	return <h1>Płatności</h1>;
}

function cartReducer(state, action) {
	switch(action.type) {
		case 'add': {
			return {
				...state,
				[action.id]: {
					name: action.name,
					count: (state[action.id] ? state[action.id].count : 0) + action.count
				}
			}
		}
	}
}

function App() {
	const [cartState, cartDispatch] = useReducer(cartReducer, {})

	return (
		<BrowserRouter>
			{/* Navigation */}
			<nav>
				<Link to="/">Główna</Link> |{" "}
				<Link to="/products">Produkty</Link> |{" "}
				<Link to="/cart">Koszyk</Link> |{" "}
				<Link to="/payments">Płatności</Link>
			</nav>

			{/* Routes */}
			<Routes>
				<Route path="/" element={<Home />} />
				<Route path="/products" element={<Products dispatch={cartDispatch}/>} />
				<Route path="/cart" element={<Cart state={cartState}/>}/>
				<Route path="/payments" element={<Payments />} />
			</Routes>
		</BrowserRouter>
	);
}

export default App
