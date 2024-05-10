import React, { createContext, useContext, useReducer } from 'react';

const CartContext = createContext();

const initialState = {
    items: [],
};

function cartReducer(state, action) {
    switch (action.type) {
        case 'ADD_TO_CART':
            const existingIndex = state.items.findIndex(item => item.id === action.payload.id);
            if (existingIndex >= 0) {
                const items = state.items.map((item, index) => {
                    if (index === existingIndex) {
                        return { ...item, quantity: item.quantity + 1 };
                    }
                    return item;
                });
                return { ...state, items };
            } else {
                return { ...state, items: [...state.items, { ...action.payload, quantity: 1 }] };
            }
        case 'REMOVE_FROM_CART':
            return {
                ...state,
                items: state.items.filter(item => item.id !== action.payload.id),
            };
        case 'UPDATE_QUANTITY':
            return {
                ...state,
                items: state.items.map(item =>
                    item.id === action.payload.id ? { ...item, quantity: action.payload.quantity } : item
                ),
            };
        default:
            return state;
    }
}

export const CartProvider = ({ children }) => {
    const [state, dispatch] = useReducer(cartReducer, initialState);

    const addToCart = item => {
        dispatch({ type: 'ADD_TO_CART', payload: item });
    };

    const removeFromCart = id => {
        dispatch({ type: 'REMOVE_FROM_CART', payload: { id } });
    };

    const updateQuantity = (id, quantity) => {
        dispatch({ type: 'UPDATE_QUANTITY', payload: { id, quantity } });
    };

    return (
        <CartContext.Provider value={{ cart: state, addToCart, removeFromCart, updateQuantity }}>
            {children}
        </CartContext.Provider>
    );
};

export const useCart = () => useContext(CartContext);
