import './App.css'
import { Products } from './Products'
import { Cart } from './Cart'
import { Payments } from './Payments';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { useReducer } from 'react';

function Home() {
	return <h1>Home Page</h1>;
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
		case 'remove': {
			var newCount = state[action.id].count - action.count
			return newCount <= 0
				? Object.fromEntries(Object.entries(state).filter(([key]) => key != action.id))
				: {
					...state,
					[action.id]: {
						...state[action.id],
						count: newCount
					}
				}
		}
		case 'clear': {
			return {}
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
				<Route path="/cart" element={<Cart state={cartState} dispatch={cartDispatch}/>}/>
				<Route path="/payments" element={<Payments state={cartState} dispatch={cartDispatch}/>} />
			</Routes>
		</BrowserRouter>
	);
}

export default App
