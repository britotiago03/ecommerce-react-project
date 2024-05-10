import React, { useState } from 'react';

function Checkout() {
    const [formData, setFormData] = useState({
        name: '',
        address: '',
        creditCard: '',
    });

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        // Here you would normally handle payment processing and order creation
        console.log('Form data submitted:', formData);
        alert('Order placed successfully!');
    };

    return (
        <form onSubmit={handleSubmit}>
            <div>
                <label>Name</label>
                <input type="text" name="name" value={formData.name} onChange={handleChange} required />
            </div>
            <div>
                <label>Address</label>
                <input type="text" name="address" value={formData.address} onChange={handleChange} required />
            </div>
            <div>
                <label>Credit Card Number</label>
                <input type="text" name="creditCard" value={formData.creditCard} onChange={handleChange} required />
            </div>
            <button type="submit">Place Order</button>
        </form>
    );
}

export default Checkout;
