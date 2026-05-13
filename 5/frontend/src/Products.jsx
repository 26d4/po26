import axios from "axios";
import { useEffect, useState } from "react";
import { API_URL } from "./global";

function Product({id, name, price, dispatch}) {
    return <>{name}: {price} <button onClick={() => dispatch({type: 'add', id, count: 1, name})}>Do koszyka</button></>
}

function Products({dispatch}) {
	const [data, setData] = useState([])
	const [loading, setLoading] = useState([true])
	const [error, setError] = useState(null)

	useEffect(() => {
		axios
			.get(API_URL + '/products')
			.then((response) => {
                setData(response.data);
                setLoading(false);
            })
            .catch((err) => {
                setError(err.message);
                setLoading(false);
            });
	}, [])

	if (loading) return <div>Wczytywanie...</div>;
    if (error) return <div>Błąd: {error}</div>;

    return (
        <div>
            <h1>Produkty</h1>
            <ul>
                {Object.entries(data).map(([id, p]) => (
                    <li key={id}><Product id={id} name={p.name} price={p.price} dispatch={dispatch}/></li>
                ))}
            </ul>
        </div>
    );
}

export { Products }