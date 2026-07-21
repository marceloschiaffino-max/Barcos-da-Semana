import React, { useEffect, useMemo, useRef, useState } from 'react'
import ReactDOM from 'react-dom/client'
import { createClient } from '@supabase/supabase-js'
import {
  addWeeks, format, getISOWeek, getYear, startOfWeek, subWeeks
} from 'date-fns'
import { ptBR } from 'date-fns/locale'
import {
  ChevronLeft, ChevronRight, ClipboardCopy, Copy, LoaderCircle,
  RefreshCw, Save, Trash2
} from 'lucide-react'
import './styles.css'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY
const configured = Boolean(supabaseUrl && supabaseKey)
const supabase = configured ? createClient(supabaseUrl, supabaseKey) : null

const DAYS = [
  { key: 'tue', short: '3ª', label: 'Terça-feira', offset: 1 },
  { key: 'wed', short: '4ª', label: 'Quarta-feira', offset: 2 },
  { key: 'thu', short: '5ª', label: 'Quinta-feira', offset: 3 },
  { key: 'fri', short: '6ª', label: 'Sexta-feira', offset: 4 },
]
const TIMES = ['06:30', '07:30']
const BOATS = [
  { key: '4x', label: '4x', seats: 4 },
  { key: '2x', label: '2x', seats: 2 },
  { key: 'skiff-yellow', label: 'Skiff Amarelo', seats: 1 },
  { key: 'skiff-red', label: 'Skiff Vermelho', seats: 1 },
  { key: 'caravela', label: 'Caravela', seats: 4, sides: ['BB', 'BE', 'BB', 'BE'] },
]

function isoDate(date) {
  return format(date, 'yyyy-MM-dd')
}
function slotId(day, time, boat, seat) {
  return `${day}|${time}|${boat}|${seat}`
}
function mondayOf(date = new Date()) {
  return startOfWeek(date, { weekStartsOn: 1 })
}
function displayRange(monday) {
  const friday = addWeeks(monday, 0)
  friday.setDate(monday.getDate() + 4)
  const sameMonth = monday.getMonth() === friday.getMonth()
  return sameMonth
    ? `${format(monday, 'd')} a ${format(friday, "d 'de' MMMM", { locale: ptBR })}`
    : `${format(monday, "d 'de' MMM", { locale: ptBR })} a ${format(friday, "d 'de' MMM", { locale: ptBR })}`
}
function normalizeName(value) {
  return value.trim().replace(/\s+/g, ' ')
}
function App() {
  const [weekStart, setWeekStart] = useState(mondayOf())
  const [activeDay, setActiveDay] = useState('tue')
  const [values, setValues] = useState({})
  const [status, setStatus] = useState('idle')
  const [message, setMessage] = useState('')
  const [suggestions, setSuggestions] = useState([])
  const saveTimers = useRef({})

  const weekKey = isoDate(weekStart)

  const loadWeek = async () => {
    if (!configured) return
    setStatus('loading')
    const { data, error } = await supabase
      .from('boat_assignments')
      .select('*')
      .eq('week_start', weekKey)
    if (error) {
      setMessage(`Erro ao carregar: ${error.message}`)
      setStatus('error')
      return
    }
    const next = {}
    for (const row of data || []) {
      next[slotId(row.day_key, row.time_key, row.boat_key, row.seat_index)] = row.athlete_name || ''
    }
    setValues(next)
    setStatus('idle')
  }

  const loadSuggestions = async () => {
    if (!configured) return
    const { data } = await supabase
      .from('boat_assignments')
      .select('athlete_name')
      .neq('athlete_name', '')
      .order('athlete_name')
      .limit(1000)
    const unique = [...new Set((data || []).map(x => x.athlete_name).filter(Boolean))]
    setSuggestions(unique)
  }

  useEffect(() => {
    loadWeek()
  }, [weekKey])

  useEffect(() => {
    loadSuggestions()
  }, [])

  useEffect(() => {
    if (!configured) return
    const channel = supabase
      .channel(`boat-assignments-${weekKey}`)
      .on(
        'postgres_changes',
        { event: '*', schema: 'public', table: 'boat_assignments', filter: `week_start=eq.${weekKey}` },
        () => loadWeek()
      )
      .subscribe()
    return () => supabase.removeChannel(channel)
  }, [weekKey])

  const saveSlot = async (dayKey, timeKey, boat, seatIndex, rawName) => {
    if (!configured) return
    const name = normalizeName(rawName)
    const id = slotId(dayKey, timeKey, boat.key, seatIndex)
    setStatus('saving')

    const duplicate = Object.entries(values).find(([otherId, otherName]) => {
      if (otherId === id || !name) return false
      const [d, t] = otherId.split('|')
      return d === dayKey && t === timeKey && normalizeName(otherName).toLocaleLowerCase('pt-BR') === name.toLocaleLowerCase('pt-BR')
    })
    if (duplicate) {
      setMessage(`${name} já está escalado neste horário.`)
      setStatus('error')
      return
    }

    let error
    if (!name) {
      const response = await supabase.from('boat_assignments').delete().match({
        week_start: weekKey,
        day_key: dayKey,
        time_key: timeKey,
        boat_key: boat.key,
        seat_index: seatIndex,
      })
      error = response.error
    } else {
      const response = await supabase.from('boat_assignments').upsert({
        week_start: weekKey,
        day_key: dayKey,
        time_key: timeKey,
        boat_key: boat.key,
        seat_index: seatIndex,
        side: boat.sides?.[seatIndex] || null,
        athlete_name: name,
        updated_at: new Date().toISOString(),
      }, { onConflict: 'week_start,day_key,time_key,boat_key,seat_index' })
      error = response.error
    }

    if (error) {
      setMessage(`Erro ao salvar: ${error.message}`)
      setStatus('error')
    } else {
      setStatus('saved')
      setMessage('Alterações salvas.')
      setTimeout(() => setStatus('idle'), 1300)
      if (name && !suggestions.includes(name)) setSuggestions(prev => [...prev, name].sort())
    }
  }

  const changeValue = (dayKey, timeKey, boat, seatIndex, value) => {
    const id = slotId(dayKey, timeKey, boat.key, seatIndex)
    setValues(prev => ({ ...prev, [id]: value }))
    clearTimeout(saveTimers.current[id])
    saveTimers.current[id] = setTimeout(
      () => saveSlot(dayKey, timeKey, boat, seatIndex, value),
      750
    )
  }

  const copyPreviousWeek = async () => {
    if (!configured) return
    if (!confirm('Copiar a escala da semana anterior para esta semana? Os campos atuais serão substituídos.')) return
    setStatus('loading')
    const previousKey = isoDate(subWeeks(weekStart, 1))
    const { data, error } = await supabase
      .from('boat_assignments')
      .select('*')
      .eq('week_start', previousKey)
    if (error) {
      setMessage(error.message); setStatus('error'); return
    }
    await supabase.from('boat_assignments').delete().eq('week_start', weekKey)
    if (data?.length) {
      const rows = data.map(({ id, created_at, ...row }) => ({
        ...row,
        week_start: weekKey,
        updated_at: new Date().toISOString(),
      }))
      const result = await supabase.from('boat_assignments').insert(rows)
      if (result.error) {
        setMessage(result.error.message); setStatus('error'); return
      }
    }
    await loadWeek()
    setMessage('Semana anterior copiada.')
    setStatus('saved')
  }

  const clearWeek = async () => {
    if (!configured) return
    if (!confirm('Apagar toda a escala desta semana?')) return
    setStatus('loading')
    const { error } = await supabase.from('boat_assignments').delete().eq('week_start', weekKey)
    if (error) {
      setMessage(error.message); setStatus('error'); return
    }
    setValues({})
    setMessage('Semana limpa.')
    setStatus('saved')
  }

  const whatsappText = useMemo(() => {
    const friday = new Date(weekStart)
    friday.setDate(weekStart.getDate() + 4)
    const lines = [
      `Sugestão de agenda para próxima semana (*${format(weekStart, 'd')} a ${format(friday, "d 'de' MMMM", { locale: ptBR })}*)`,
      'Segue a lista:',
      ''
    ]
    for (const day of DAYS) {
      for (const time of TIMES) {
        lines.push(`*${day.short} feira ${time.replace(':', 'h')}*`)
        for (const boat of BOATS) {
          if (boat.key === 'caravela') {
            lines.push('Caravela')
            for (let i = 0; i < boat.seats; i++) {
              const name = values[slotId(day.key, time, boat.key, i)] || ''
              lines.push(`       ${boat.sides[i]} ${name}`)
            }
          } else {
            const names = Array.from({ length: boat.seats }, (_, i) =>
              values[slotId(day.key, time, boat.key, i)] || ''
            ).filter(Boolean)
            lines.push(`${boat.label} - ${names.join(' / ')}`)
          }
        }
        lines.push('')
      }
    }
    lines.push('Nota: as posições na Caravela não indicam voga ou proa; apenas os bordos.')
    return lines.join('\n')
  }, [values, weekKey])

  const copyWhatsApp = async () => {
    await navigator.clipboard.writeText(whatsappText)
    setMessage('Mensagem copiada. Agora é só colar no WhatsApp.')
    setStatus('saved')
  }

  if (!configured) {
    return (
      <main className="setup">
        <div className="setup-card">
          <h1>Barcos da Semana</h1>
          <p>O site está pronto, mas faltam as variáveis do Supabase.</p>
          <code>VITE_SUPABASE_URL</code>
          <code>VITE_SUPABASE_PUBLISHABLE_KEY</code>
          <p>Consulte o arquivo README.md do projeto.</p>
        </div>
      </main>
    )
  }

  return (
    <main className="app-shell">
      <header className="topbar">
        <div>
          <p className="eyebrow">ESCALA DE REMO</p>
          <h1>Barcos da Semana</h1>
        </div>
        <div className={`save-state ${status}`}>
          {status === 'saving' || status === 'loading' ? <LoaderCircle size={16} className="spin" /> : <Save size={16} />}
          <span>{status === 'saving' ? 'Salvando…' : status === 'loading' ? 'Carregando…' : status === 'saved' ? 'Salvo' : 'Online'}</span>
        </div>
      </header>

      <section className="week-picker">
        <button aria-label="Semana anterior" onClick={() => setWeekStart(w => subWeeks(w, 1))}><ChevronLeft /></button>
        <div>
          <strong>Semana {getISOWeek(weekStart)} · {getYear(weekStart)}</strong>
          <span>{displayRange(weekStart)}</span>
        </div>
        <button aria-label="Próxima semana" onClick={() => setWeekStart(w => addWeeks(w, 1))}><ChevronRight /></button>
      </section>

      <nav className="day-tabs">
        {DAYS.map(day => (
          <button key={day.key} className={activeDay === day.key ? 'active' : ''} onClick={() => setActiveDay(day.key)}>
            <span>{day.short}</span>
            <small>{format(new Date(weekStart.getFullYear(), weekStart.getMonth(), weekStart.getDate() + day.offset), 'dd/MM')}</small>
          </button>
        ))}
      </nav>

      {message && <div className={`notice ${status === 'error' ? 'error' : ''}`} onClick={() => setMessage('')}>{message}</div>}

      <section className="schedule">
        {TIMES.map(time => (
          <div className="time-card" key={time}>
            <div className="time-heading">
              <h2>{time.replace(':', 'h')}</h2>
              <span>{DAYS.find(d => d.key === activeDay)?.label}</span>
            </div>
            <div className="boats">
              {BOATS.map(boat => (
                <div className={`boat ${boat.key === 'caravela' ? 'caravela' : ''}`} key={boat.key}>
                  <div className="boat-title">
                    <strong>{boat.label}</strong>
                    <small>{boat.seats} {boat.seats === 1 ? 'vaga' : 'vagas'}</small>
                  </div>
                  <div className="seats">
                    {Array.from({ length: boat.seats }, (_, seatIndex) => {
                      const id = slotId(activeDay, time, boat.key, seatIndex)
                      return (
                        <label className="seat" key={id}>
                          {boat.sides && <span className="side">{boat.sides[seatIndex]}</span>}
                          <input
                            list="athletes"
                            placeholder="Nome do atleta"
                            value={values[id] || ''}
                            onChange={e => changeValue(activeDay, time, boat, seatIndex, e.target.value)}
                            onBlur={e => saveSlot(activeDay, time, boat, seatIndex, e.target.value)}
                          />
                        </label>
                      )
                    })}
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}
      </section>

      <datalist id="athletes">
        {suggestions.map(name => <option key={name} value={name} />)}
      </datalist>

      <section className="actions">
        <button onClick={copyPreviousWeek}><Copy size={18} /> Copiar semana anterior</button>
        <button onClick={loadWeek}><RefreshCw size={18} /> Atualizar</button>
        <button className="primary" onClick={copyWhatsApp}><ClipboardCopy size={18} /> Copiar para WhatsApp</button>
        <button className="danger" onClick={clearWeek}><Trash2 size={18} /> Limpar semana</button>
      </section>

      <footer>
        <p>Na Caravela, BB/BE indicam apenas os bordos, não voga ou proa.</p>
      </footer>
    </main>
  )
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode><App /></React.StrictMode>
)
