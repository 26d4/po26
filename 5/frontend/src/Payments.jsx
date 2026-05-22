import axios from "axios";
import PropTypes from "prop-types";
import { useEffect, useState } from "react";

function Payments({state, dispatch}) {
	function doPayment(state, dispatch) {
		let info = Object.fromEntries(Object.entries(state).map(([id, p]) => [id, p.count]))

		axios
			.post(import.meta.env.VITE_API_URL + '/payment', info)
			.then((response) => {
				dispatch({type: 'clear'})
				alert('Zapłacono ' + response.data.paid)
			})
			.catch((err) => {
				alert('Zapłata nie powiodła się: ' + err.message)
			})
	}
	
	const [data, setData] = useState([])
	const [loading, setLoading] = useState([true])
	const [error, setError] = useState(null)

	useEffect(() => {
		axios
			.get(import.meta.env.VITE_API_URL + '/products')
			.then((response) => {
                setData(response.data);
                setLoading(false);
            })
            .catch((err) => {
                setError(err.message);
                setLoading(false);
            });
	}, [])

	if (loading) { return <div>Wczytywanie...</div> }
    if (error) { return <div>Błąd: {error}</div> }

	let payment = Object.keys(state).reduce((p, id) => p + data[id].price * state[id].count, 0)

	return (
		<div>
			<h1>Płatności</h1>
			{(() => {for (const k in state) {return true}; return false})() ? (
				<>
					<ul>
						{Object.entries(state).map(([id, p]) => (
							<li key={id}>{p.name}: {p.count}*{data[id].price}={p.count*data[id].price}</li>
						))}
					</ul>
					<button onClick={() => doPayment(state, dispatch)}>Zapłać {payment}</button>
				</>
			) : (
				<>Brak płatności</>
			)}
		</div>
	)
}

Payments.propTypes = {
	state: PropTypes.object,
	dispatch: PropTypes.func
}

export { Payments }