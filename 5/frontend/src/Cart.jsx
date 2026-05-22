import PropTypes from "prop-types"

function CartEntry({id, name, count, dispatch}) {
	return (
		<>
			{name}: {count} {' '}
			<button onClick={() => dispatch({type: 'remove', id, count: 1})}>Usuń 1</button>
			<button onClick={() => dispatch({type: 'remove', id, count})}>Usuń Wszystkie</button>
		</>
	)
}

function Cart({state, dispatch}) {
	return (
		<div>
			<h1>Koszyk</h1>
			{(() => {for (const k in state) {return true}; return false})() ? (
				<ul>
					{Object.entries(state).map(([id, p]) => (
						<li key={id}><CartEntry id={id} name={p.name} count={p.count} dispatch={dispatch}></CartEntry></li>
					))}
				</ul>
			) : (
				<>Koszyk jest pusty</>
			)}
		</div>
	)
}

CartEntry.propTypes = {
	id: PropTypes.number,
	name: PropTypes.string,
	count: PropTypes.number,
	dispatch: PropTypes.func
}

Cart.propTypes = {
	state: PropTypes.object,
	dispatch: PropTypes.func
}

export { Cart }