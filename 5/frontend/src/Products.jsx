import axios from "axios";
import { useEffect, useState } from "react";
import global from "./global";

function Products() {
	const [data, setData] = useState([])
	const [loading, setLoading] = useState([true])
	const [error, setError] = useState(null)

	useEffect(() => {
		axios
			.get(global.API_URL + '/products')
			.then((response) => {
                setData(response.data);
                setLoading(false);
            })
            .catch((err) => {
                setError(err.message);
                setLoading(false);
            });
	}, [])

	if (loading) return <div>Loading...</div>;
    if (error) return <div>Error: {error}</div>;

    return (
        <div>
            <h1>Produkty</h1>
            <ul>
                {data.map((p) => (
                    <li key={p.id}>{p.name}: {p.price}</li>
                ))}
            </ul>
        </div>
    );
}

export { Products }