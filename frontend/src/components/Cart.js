import React from 'react';
import { useCart } from '../contexts/CartContext';
import '../css/Cart.css'

function Cart() {
    const { cart, removeFromCart, updateQuantity } = useCart();

    if (!cart.items.length) {
        return <div>Your cart is empty.</div>;
    }

    const handleQuantityChange = (id, event) => {
        updateQuantity(id, parseInt(event.target.value));
    };

    return (
        <div className="cart-container">
            <h1>Your Shopping Cart</h1>
            <div className="cart-container-list">
                {cart.items.map(item => (
                    <div key={item.id} className="cart-item">
                        <img src={item.ImageURL} alt={item.Name} style={{ width: '100px', height: '100px' }} />
                        <div>
                            <h3>{item.Name}</h3>
                            <p>{item.Price},-</p>
                            <p>
                                Quantity:
                                <input
                                    type="number"
                                    value={item.quantity}
                                    onChange={e => handleQuantityChange(item.id, e)}
                                    min="1"
                                    max="99"
                                />
                            </p>
                            <button onClick={() => removeFromCart(item.id)}>Remove from Cart</button>
                        </div>
                    </div>
                ))}
            </div>
            <div>
                <h3>Total: {cart.items.reduce((total, item) => total + item.quantity * item.Price, 0).toFixed(2)},-</h3>
                <button onClick={() => alert('Proceed to Checkout')}>Checkout</button>
            </div>
        </div>
    );
}

export default Cart;
