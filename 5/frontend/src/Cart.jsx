function Cart({state}) {
	return (
		<div>
			<h1>Koszyk</h1>
			<ul>
				{Object.entries(state).map(([id, p]) => (
					<li key={id}>{p.name}: {p.count}</li>
				))}
			</ul>
		</div>
	)
}

export { Cart }