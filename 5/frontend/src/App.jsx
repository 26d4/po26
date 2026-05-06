import './App.css'
import { Products } from './Products'
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';

function Home() {
	return <h1>Home Page</h1>;
}

function Payments() {
	return <h1>Płatności</h1>;
}

function App() {
	return (
		<BrowserRouter>
			{/* Navigation */}
			<nav>
				<Link to="/">Główna</Link> |{" "}
				<Link to="/products">Produkty</Link> |{" "}
				<Link to="/payments">Płatności</Link>
			</nav>

			{/* Routes */}
			<Routes>
				<Route path="/" element={<Home />} />
				<Route path="/products" element={<Products />} />
				<Route path="/payments" element={<Payments />} />
			</Routes>
		</BrowserRouter>
	);
}

export default App
